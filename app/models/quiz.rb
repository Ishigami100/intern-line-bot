require "httpclient"
class Quiz < ApplicationRecord
    CHALLENGE_UPPER_LIMIT = 5
    MAX_POKEMON_ID = 151
    
    BASE_URL = "https://pokeapi.co/api/v2"
    POKEMON_SPECIES_URL = "/pokemon-species/"
    POKEMON_URL = "/pokemon/"

    belongs_to :user 
    has_many :answers

    def self.start_quiz(user)
        Quiz.create(user_id: user.id, pokemon_id: random_pokemon_id, challenge_upper_limit: CHALLENGE_UPPER_LIMIT)
    end

    def answer(answer_text:)
        answers.create(quiz_id: self.id,answer_text: answer_text,answer_succeed: is_answer_succeed?(answer_text))
    end

    def one_quiz_to_answer_num
        answers.count
    end

    def question_message
        str = '問題！このポケモンはなんでしょう？ '+pokemon_id.to_s
        question_message = {
            type: 'text',
            text: str
        }
    end

    def image_message(base_url)
        image_url = "#{base_url}#{ActionController::Base.helpers.asset_url('gray/'+format("%03d", pokemon_id))}"
        p image_url
        image_message = {
            type: 'image',
            originalContentUrl: image_url,
            previewImageUrl:  image_url
        }
    end

    def reply_message
        if answers.last.answer_succeed == true
            message = '正解！！'
        else
            if answers.count >=  CHALLENGE_UPPER_LIMIT
                message = '残念でした。また次回挑戦してください。'
            else
                message =  '違います。再度答えを入力してください。'
            end
        end
        question_message = {
            type: 'text',
            text: message
        }
    end

    private 

    def self.random_pokemon_id
        rand(1..MAX_POKEMON_ID)
    end

    def is_answer_succeed?(input_text)
        return false if validate_text?(input_text)
        answer_text = pokemon_name_jp(self.pokemon_id)
        if  input_text == answer_text
            true
        else
            false
        end
    end

    def validate_text?(input_text)
        return false if is_katakana?(input_text)
        #ここにvalidatonを追記する
        return true
    end

    #ひら→カタ
    def self.to_kana(text)
        text.tr('ぁ-ん','ァ-ン')
    end

    #ひらがな？
    def self.is_kana?(text)
        return true if text =~ /\A[ぁ-んー－]+\z/
        false
    end

    #漢字？
    def self.is_kanji?(text)
        return true if text =~ /^[一-龥]+$/
        false
    end

    #カタカナ？
    def is_katakana?(text)
        return true if text =~ /\A[ァ-ヶー－]+\z/
        false
    end 

    def pokemon_species
        url = "#{BASE_URL}#{POKEMON_SPECIES_URL}#{self.pokemon_id.to_s}"
        client = HTTPClient.new                 # インスタンスを生成
        response = client.get(url)   
        JSON.parse(response.body) 
    end

    def pokemon_name(language) #'en' 'zh-Hant' 'ja-Hrkt'
        results=pokemon_species
        results['names'].each do |name_info|
            if name_info['language']['name'] == language
                return name_info['name']
            end
        end
        return "Not Found"
    end

    def pokemon_text_jp
        results=pokemon_species
        results['flavor_text_entries'].each do |flavor_text_entries_info|
            if flavor_text_entries_info['language']['name']== "ja" || flavor_text_entries_info['language']['name'] == "ja-Hrkt"
                return flavor_text_entries_info['flavor_text']
            end
        end
        return "Not Found"
    end

    def pokemon_type_jp
        url = "#{BASE_URL}#{POKEMON_URL}#{self.pokemon_id.to_s}"
        types=[]
        client = HTTPClient.new                 # インスタンスを生成
        response = client.get(url)   
        results=JSON.parse(response.body) 
        results['types'].each do |type_en|
            response_type = client.get(type_en['type']['url'])
            results_type=JSON.parse(response_type.body)
            results_type['names'].each do |type_name|
                p type_name
                if type_name['language']['name'] == "ja-Hrkt"
                    types.push(type_name['name'])
                end
            end
        end
        return types
    end
end