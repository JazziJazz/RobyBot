module RobyBot
    module Events
        module OnPlayerEnter
            extend Discordrb::EventContainer
            extend RobyBot::MyOwnFunctions

            member_join do |_server_each|
                unless _server_each.member.bot_account;

                    #  1.A; Quando o membro entra no servidor, então adicionamos ao contador de membros de seu respectivo server a quantidade de mais um membro.
                    CONN.exec("UPDATE SERVERS SET SERVER_MEMBERS = (SERVER_MEMBERS + 1) WHERE SERVER_ID = #{_server_each.server.id};")

                    joined_date_member = _server_each.member.joined_at.to_s.split(" ")[0].gsub("-", "/")  #  Variável que armazena o formato da data de entrada do membro.

                    #  1.B; Inserimos o membro dentro da tabela de membros do seu respectivo server.
                    CONN.exec("INSERT INTO MEMBERS
                               (SERVER_ID, MEMBER_ID, MEMBER_DISCRIM, MEMBER_USERNAME, MEMBER_NICK, JOINED_AT)
                           VALUES
                               (#{_server_each.server.id}, #{_server_each.member.id}, #{_server_each.member.discriminator}, '#{_server_each.member.username}', NULL, '#{joined_date_member}');")


                    #  2.A; Bloco de código referente a atualização de informações dos membros no canal "🤡roby-server-members".
                    update_embed(_server_each, "🤡roby-server-members")
                end

            end

        end
    end
end
