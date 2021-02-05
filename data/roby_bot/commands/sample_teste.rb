module RobyBot
    module Commands
        module CommandTest
            extend Discordrb::Commands::CommandContainer

            command(:warning, min_args: 2, description: "Comando para adição de um warning em determinado membro.", usage: '!warning add [discord_member]', required_permissions: [:kick_members]) do |_event, add_or_remove, member|
                #  Aqui separamos o discriminator do username do parâmetro member.
                member = member.split("#")

                member = BOT.find_user(member[0], member[1])
                member_warnings = CONN.exec("SELECT WARNINGS FROM MEMBERS WHERE MEMBER_ID = #{member.id};").values

                #  Se o jogador estiver dentro da lista de membros do servidor, e o parâmetro add_or_remove for 'add'.
                if _event.server.members.include?(member) and (add_or_remove == "add");
                    if member_warnings.flatten[0].to_i >= 3;
                        BOT.pm_channel(member.id).send_message("Você foi **expulso** do servidor **#{_event.server.name}** pelo **#{_event.author.name}**. Você atingiu o **número máximo de avisos**, caso queira voltar, entre em contato com um administrador do servidor que foi expulso.")
                        _event.server.kick(member.id, reason: "Atingiu o limite máximo de avisos.")
                    else
                        CONN.exec("UPDATE MEMBERS SET WARNINGS = (WARNINGS + 1) WHERE MEMBER_ID = #{member.id};")
                        _event.respond "Warning adicionado por #{_event.author.name} ao #{member.name}."

                    end
                elsif _event.server.members.include?(member) and (add_or_remove == "remove")
                    unless member_warnings.flatten[0].to_i <= 0;
                        CONN.exec("UPDATE MEMBERS SET WARNINGS = (WARNINGS - 1) WHERE MEMBER_ID = #{member.id};")
                        _event.respond "Um warning foi removido por #{_event.author.name} de #{member.name}."
                    end
                end

            end

        end
    end
end
