module RobyBot
    module MyOwnFunctions

        def create_embed(_event_name, _channel_name)
            channel = BOT.find_channel(_channel_name, _event_name.server.name)

            if channel;
                BOT.channel(channel[0].id, _event_name.server).send_embed do |_embed|
                    _embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: BOT.bot_user.avatar_url)
                    _embed.title = "Lista de Membros do Servidor:"
                    _embed.description = "Abaixo é exibida a lista de membros do servidor com seus respectivos níveis de aviso."
                    _embed.colour = "#FF0000"  #  Coloração vermelha para o embed.

                    #  1.A; Looping que pega todos os usuários do servidor no instante que um membro novo adentra o servidor.
                    BOT.server(_event_name.server).non_bot_members.each do |member|
                        warning_table = CONN.exec("SELECT WARNINGS FROM MEMBERS WHERE MEMBER_ID = #{member.id};").values

                        if member.nick;
                            _embed.add_field(name: "```#{member.nick}```", value: "Esse membro possui um total de #{warning_table[0][0]} avisos.", inline: true)
                        else
                            _embed.add_field(name: "```#{member.name}##{member.discriminator}```", value: "Esse membro possui um total de #{warning_table[0][0]} avisos.", inline: true)
                        end
                    end
                end.await!(timeout: 5)

                BOT.channel(channel[0].id, _event_name.server).send_embed do |_embed|
                    _embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://w7.pngwing.com/pngs/1022/907/png-transparent-yellow-and-black-warning-sign-icon-warning-icons-angle-triangle-sign.png")
                    _embed.title = "Adicionando ou Removendo Avisos!"
                    _embed.description = "Você quer adicionar ou remover avisos de jogadores? Então se liga só na documentação dos comandos disponíveis abaixo!"
                    _embed.colour = "#FF0000"

                    _embed.add_field(name: "```!warning add [name_of_discord]```", value: "Esse comando **adiciona** um warning no membro da sua facção. O **parâmetro utilizado** é o **Discord** do membro e **não** o seu apelido dentro do servidor, fique atento a isso ou você irá falhar.")
                    _embed.add_field(name: "```!warning remove [name_of_discord]```", value: "Esse comando **remove** um warning no membro da sua facção. O **parâmetro utilizado** é o **Discord** do membro e **não** o seu apelido dentro do servidor, fique atento a isso ou você irá falhar.")

                    _embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Quando um jogador atinge a quantidade de três avisos (_warnings_) em sua conta, ele é automaticamente BANIDO do servidor do Discord de sua facção. Se lembre de utilizar os comandos no canal 🤖roby-comandos.", icon_url: "https://i.pinimg.com/originals/fb/d1/e9/fbd1e95fc924fd69a44cf8fb27c47683.jpg")
                end
            end
        end

        def remove_embed(_event_name, _channel_name, _number_of_messages = 2)
            channel = BOT.find_channel(_channel_name, _event_name.server.name)

            if channel;
                BOT.channel(channel[0].id, _event_name.server).prune(_number_of_messages) {|_where| _where.author.id == BOT.bot_user.id}
            end
        end

        def update_embed(_event_name, _channel_name, _number_of_embeds = 2)
            remove_embed(_event_name, _channel_name, _number_of_embeds)
            create_embed(_event_name, _channel_name)
        end

    end
end
