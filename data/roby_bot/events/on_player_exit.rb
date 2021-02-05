module RobyBot
    module Events
        module OnPlayerExit
            extend Discordrb::EventContainer
            extend RobyBot::MyOwnFunctions

            member_leave do |_server_each|
                unless _server_each.member.bot_account;

                    #  1.A; Bloco de código que deleta as informações do membro após ele sair do servidor.
                    CONN.exec("DELETE FROM MEMBER_ROLES WHERE MEMBER_ID = #{_server_each.member.id};")
                    CONN.exec("DELETE FROM MEMBERS WHERE MEMBER_ID = #{_server_each.member.id};")
                    CONN.exec("UPDATE SERVERS SET SERVER_MEMBERS = (SERVER_MEMBERS - 1) WHERE SERVER_ID = #{_server_each.server.id};")


                    #  2.A; Bloco de código referente a atualização de informações dos membros no canal "🤡roby-server-members".
                    update_embed(_server_each, "🤡roby-server-members")
                end

            end

        end
    end
end
