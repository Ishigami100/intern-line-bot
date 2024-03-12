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
            if user.current_quiz.answers.count >= Quiz::CHALLENGE_UPPER_LIMIT || (!user.current_quiz.answers.last.nil? && user.current_quiz.answers.last.answer_succeed == true)
              quiz=Quiz.start_quiz(user)
              client.reply_message(event['replyToken'],quiz.image_message_start(request.base_url))
              client.push_message(line_user_id,quiz.question_message)
            else
              explain_text={
                type: 'text',
                text: 'まだ回答済みでない問題があります。確認してください。'
              }
              client.reply_message(event['replyToken'],explain_text)
            end
          else
            user.current_quiz.delete_image_gray_check
            user.current_quiz.answer(answer_text: event.message['text'])
            if user.current_quiz.reply_message[:text].include?("正解")
              client.reply_message(event['replyToken'],user.current_quiz.image_message_end(request.base_url))
              sleep(2)
              user.current_quiz.delete_image_normal_check
            end
            client.push_message(line_user_id,user.current_quiz.reply_message)
          end
        end
      end
    }
    head :ok
  end
end
