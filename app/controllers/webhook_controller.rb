require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          line_user_id = event['source']['userId']
          #lineのuser_idが存在しない場合に追加する
          user = User.find_or_create_by(line_user_id: line_user_id)
          #入力文字で条件分岐
          if event.message['text'] == "スタート"
            quiz=Quiz.start_quiz(user.id)
            client.reply_message(event['replyToken'],quiz.image_message(request.base_url))
            client.push_message(line_user_id,quiz.question_message)
          else
            user.current_quiz.answer(answer_text: event.message['text'])
            client.reply_message(event['replyToken'],user.current_quiz.reply_message)
          end
        end
      end
    }
    head :ok
  end
end
