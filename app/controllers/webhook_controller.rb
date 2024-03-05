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
          #入力文字で条件分岐
          if event.message['text'] == "スタート"
            #lineのuser_idが存在しない場合に追加する
            if !User.exists?(line_user_id: line_user_id)
              User.create(line_user_id: line_user_id)
            end
            quiz=Quiz.start_quiz(line_user_id)
            client.reply_message(event['replyToken'],quiz.image_message)
            client.push_message(line_user_id,quiz.question_message)
          else
            user=User.find_by(line_user_id: line_user_id)
            user.current_quiz.answer(answer_text: event.message['text'])
            client.reply_message(event['replyToken'],user.current_quiz.reply_message)
          end
        end
      end
    }
    head :ok
  end
end
