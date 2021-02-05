module RobyBot
    module Events
        module OnMessageAttachment
            extend Discordrb::EventContainer
            messages = []

            message do |event|
                #  Verificação, se a mensagem for um arquivo e foi enviada em um canal com o nome de, então faça alguma coisa;
                if not event.message.attachments[0].nil? and (event.message.channel.name == "🧙♂roby-av-screenshots");
                    messages.push(event.message)

                    emojis_to_add = %w[✅ ❎]
                    emojis_to_add.each { |emoji| event.message.create_reaction(emoji) }

                    messages[0].create_reaction("🤡")
                    messages.clear
                end
            end



        end
    end
end
