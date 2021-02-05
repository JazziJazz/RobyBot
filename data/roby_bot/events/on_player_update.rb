module RobyBot
    module Events
        module OnPlayerUpdate
            extend Discordrb::EventContainer

            member_update do |_server_each|
                unless _server_each.member.bot_account;

                    #  1.A; Se o membro possuir um nick então ele é inserido dentro do banco de dados.
                    if _server_each.member.nick;
                        CONN.exec("UPDATE MEMBERS SET MEMBER_NICK = '#{_server_each.member.nick}' WHERE MEMBER_ID = #{_server_each.member.id};")
                    end

                    #  1.B; Um reset nas roles ocorre sempre que um membro é atualizado;
                    CONN.exec("DELETE FROM MEMBER_ROLES WHERE MEMBER_ID = #{_server_each.member.id};")

                    #  1.C; Rodamos uma verificação na array de roles e adicionamos todas elas a tabela member_roles após ter deletado todas na instrução anterior.
                    _server_each.member.roles.each do |new_role|
                        unless new_role.name == "@everyone";
                            CONN.exec("INSERT INTO MEMBER_ROLES
                                           (SERVER_ID, MEMBER_ID, MEMBER_ROLE)
                                       VALUES
                                           (#{_server_each.server.id}, #{_server_each.member.id}, '#{new_role.name}')")
                        end
                    end

                end
            end

        end
    end
end
