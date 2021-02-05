module RobyBot
    module Commands
        module CreateChatTeste
            extend Discordrb::Commands::CommandContainer
            command(:create, description: 'Responds with information') do |event|
                event.channel.send_embed do |embed|
                    embed.title = "Lista de Membros do Servidor:"
                    embed.description = "Abaixo é exibida a lista de membros do servidor com seus respectivos níveis de aviso."
                    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: BOT.bot_user.avatar_url)

                    event.server.non_bot_members.each do |member|
                        if member.nick;
                            embed.add_field(name: "```#{member.nick}```", value: "Esse membro possui um total de zero avisos.", inline: true)
                        else
                            embed.add_field(name: "```#{member.name}##{member.discriminator}```", value: "Esse membro possui um total de zero avisos.", inline: true)
                        end
                    end

                    embed.colour = "#FF0000"

                end
            end
        end
    end
end

