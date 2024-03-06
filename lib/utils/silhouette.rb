require "vips"
require 'open-uri'
module Utils
    class Silhouette
        POKEMON_IMAGE_URL="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"

        def image_save(pokemon_id)
            url = "#{POKEMON_IMAGE_URL}/#{pokemon_id}.png"
            filename = File.basename(url)
            open("public/pokemon/#{filename}", 'w+b') do |output|
                URI.open(url) do |data|
                    output.puts(data.read)
                end
            end
            filename
        end

        def image_to_silhouette(pokemon_id)
            filename = image_save(pokemon_id)
            #画像を読み込む
            input_image = Vips::Image.new_from_file("public/pokemon/#{filename}")
            #グレースケールに
            greyscale_image = input_image.colourspace('b-w')
            gaussblur_image = greyscale_image.gaussblur(0.1)
            bw_image = gaussblur_image.relational_const(:more,250)
            bw_image.~.write_to_file("public/grey/#{pokemon_id}.jpg")
            return "#{pokemon_id}.jpg"
        end
    end
end
