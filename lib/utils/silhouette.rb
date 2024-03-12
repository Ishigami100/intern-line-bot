require "vips"
require 'open-uri'
module Utils
    class Silhouette
        POKEMON_IMAGE_URL="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"

        def image_save(pokemon_id,user_id)
            url = "#{POKEMON_IMAGE_URL}/#{pokemon_id}.png"
            filename = File.basename(url)
            open("public/pokemon/#{user_id}-#{filename}", 'w+b') do |output|
                URI.open(url) do |data|
                    output.puts(data.read)
                end
            end
            filename
        end

        def image_to_silhouette(pokemon_id,user_id)
            filename = image_save(pokemon_id,user_id)
            #画像を読み込む
            input_image = Vips::Image.new_from_file("public/pokemon/#{user_id}-#{filename}")
            #グレースケールに
            greyscale_image = input_image.colourspace('b-w')
            gaussblur_image = greyscale_image.gaussblur(0.1)
            bw_image = gaussblur_image.relational_const(:more,250)
            bw_image.~.write_to_file("public/grey/#{user_id}-#{pokemon_id}.jpg")
            "#{user_id}-#{pokemon_id}.jpg"
        end

        def delete_image_gray(pokemon_id,user_id)
            if File.exist?("public/grey/#{user_id}-#{pokemon_id}.jpg")  
                File.delete("public/grey/#{user_id}-#{pokemon_id}.jpg")   # ファイルを削除
            end
        end

        def delete_image_normal(pokemon_id,user_id)
            if File.exist?("public/pokemon/#{user_id}-#{pokemon_id}.png")
                File.delete("public/pokemon/#{user_id}-#{pokemon_id}.png")# ファイルを削除
            end
        end
    end
end
