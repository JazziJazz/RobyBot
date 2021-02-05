module RobyBot
    module Commands
        module Information
            extend Discordrb::Commands::CommandContainer
            command(:try, description: 'Responds with information') do |event|

                message = event.message.create_reaction('❎')
                message = event.message.create_reaction('✅')

                BOT.add_await!(Discordrb::Events::ReactionAddEvent, message: message) do |reaction|

                    if reaction.emoji.name == "✅";
                        event.message.delete
                        event.respond "Deu certo mano!"

                    elsif reaction.emoji.name == "❎";
                        event.message.delete
                        event.respond "Agora fudeu."
                    else
                        reaction.message.delete_reaction(reaction.user.id, reaction.emoji.name)
                        #  Quando chamamos next, significa que queremos que o bloco volte para o começo e refaça a volta do loop.
                        next
                    end

                    #  A instrução true encerra o loop do bloco do .add_await!
                    true
                end

                #  Essa instrução só é executada quando o bloco await é fechado.
                event.respond "Added await."
            end
        end
    end
end
