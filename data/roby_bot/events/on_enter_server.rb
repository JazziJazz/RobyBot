module RobyBot
    module Events
        module OnEnterServer
            extend Discordrb::EventContainer
            extend RobyBot::MyOwnFunctions

            #  Esse bloco de código é executado assim que o bot é adicionado a algum servidor.
            server_create do |element|

                #  Área onde o canal pai é criado, para ser utilizado posteriormente.
                BOT.server(element.server).create_channel("💎roby channels", 4).await!(timeout: 5)


                #  Uma pesquisa é feita em todos os canais dentro do servidor, se ele achar o canal anteriormente criado, então cria canais filhos para este.
                channel = BOT.find_channel("💎roby channels", element.server.name)

                if channel;
                    BOT.server(element.server).create_channel("🤖roby comandos", parent: channel[0].id).await!(timeout: 1)
                    BOT.server(element.server).create_channel("💻roby propaganda", parent: channel[0].id).await!(timeout: 1)
                    BOT.server(element.server).create_channel("🧙‍♂️roby av-screenshots", parent: channel[0].id).await!(timeout: 1)
                    BOT.server(element.server).create_channel("🤡️roby server members", parent: channel[0].id)
                end.await!(timeout: 5)


                #  Esse bloco de código trata de inserir informações sobre o servidor que adicionou o bot.
                CONN.exec("INSERT INTO SERVERS
                               (SERVER_ID, SERVER_MEMBERS, NAME_SERVER, OWNER_SERVER)
                           VALUES
                                (#{element.server.id}, #{element.server.non_bot_members.size}, '#{element.server.name}', '#{element.server.owner.name}##{element.server.owner.discriminator}')
                           ON CONFLICT DO NOTHING;")


                #  Aqui para cada canal de texto dentro deste servidor, ele ira inserir uma linha de dados dentro do SGBD, na tabela de CHANNELS.
                BOT.server(element.server.id).channels.each do |channel|
                    if channel.category?;
                        CONN.exec("INSERT INTO CHANNELS
                               (SERVER_ID, CHANNEL_ID, CHANNEL_NAME, CHANNEL_IS_PARENT, CHANNEL_PARENT_ID)
                               VALUES
                                   (#{element.server.id}, #{channel.id}, '#{channel.name}', #{channel.category?}, NULL) ON CONFLICT DO NOTHING;")
                    else
                        if channel.parent_id;
                            CONN.exec("INSERT INTO CHANNELS
                                           (SERVER_ID, CHANNEL_ID, CHANNEL_NAME, CHANNEL_IS_PARENT, CHANNEL_PARENT_ID)
                                       VALUES
                                           (#{element.server.id}, #{channel.id}, '#{channel.name}', #{channel.category?}, #{channel.parent_id}) ON CONFLICT DO NOTHING;")
                        end
                    end
                end.await!(timeout: 2)


                #  Área onde executamos o preenchimento da tabela de membros dentro do SGBD.
                BOT.server(element.server.id).non_bot_members.each do |member|
                    joined_date_member = member.joined_at.to_s.split(" ")[0].gsub("-", "/")

                    if member.nick;
                        CONN.exec("INSERT INTO MEMBERS
                                       (SERVER_ID, MEMBER_ID, MEMBER_DISCRIM, MEMBER_USERNAME, MEMBER_NICK, JOINED_AT)
                                   VALUES
                                       (#{element.server.id}, #{member.id}, #{member.discriminator}, '#{member.username}', '#{member.nick}', '#{joined_date_member}');")
                    else
                        CONN.exec("INSERT INTO MEMBERS
                                       (SERVER_ID, MEMBER_ID, MEMBER_DISCRIM, MEMBER_USERNAME, MEMBER_NICK, JOINED_AT)
                                   VALUES
                                       (#{element.server.id}, #{member.id}, #{member.discriminator}, '#{member.username}', NULL, '#{joined_date_member}');")
                    end
                end.await!(timeout: 2)


                #  Bloco de código referente ao preenchimento da tabela MEMBER_ROLES do SGBD.
                BOT.server(element.server.id).non_bot_members.each do |server_member|
                    server_member.roles.each do |role_array|
                        unless role_array.name == "@everyone"
                            CONN.exec("INSERT INTO MEMBER_ROLES
                                           (SERVER_ID, MEMBER_ID, MEMBER_ROLE)
                                       VALUES
                                           (#{element.server.id}, #{server_member.id}, '#{role_array.name}');")
                        end
                    end
                end.await!(timeout: 2)


                #  Criação do embed de avisos e informações sobre os membros.
                create_embed(element.server, "🤡roby-server-members").await!(timeout: 5)
            end
        end
    end
end


