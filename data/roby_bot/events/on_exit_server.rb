module RobyBot
    module Events
        module OnExitServer
            extend Discordrb::EventContainer
            #  Evento chamado ao servidor ser expulso, ou sair de um servidor, seja por qualquer motivo.
            server_delete do |element|

                #  Esse bloco de código elimina do banco de dados todos os dados de um servidor quando ele é removido do mesmo.
                tables = %w[MEMBER_ROLES MEMBERS CHANNELS SERVERS]
                tables.each do |table|
                    CONN.exec("DELETE FROM #{table} WHERE SERVER_ID = #{element.server};")
                end

            end
        end
    end
end
