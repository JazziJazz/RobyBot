module RobyBot
    module Events
        module OnRatedRoleplay
            extend Discordrb::EventContainer

            reaction_add(in: "🧙♂roby-av-screenshots") do |_reaction_event|
                #  Array com todas os cargos do usuário que reagiu é criada.
                reaction_member_role = CONN.exec("SELECT MEMBER_ROLE FROM MEMBER_ROLES WHERE MEMBER_ID = #{_reaction_event.user.id};").values

                #  Caso por acaso o membro que reagiu possuir determinado cargo em sua tabela de cargos então executa a condição, caso contrário as reações dele são excluidas.
                if reaction_member_role.flatten.include?('badass');

                    if _reaction_event.emoji.name == "🤡";
                        array_of_messages = []

                        _reaction_event.channel.history(10, nil, _reaction_event.message.id).each do |message|
                            if (message.author.id == _reaction_event.message.author.id) and message.reactions.inspect[49].to_i == 2;
                                array_of_messages.push(message)
                            end
                        end

                        links_of_message = ""
                        array_of_messages.reverse_each do |index|
                            links_of_message += "[img]#{index.attachments[0].url}[/img]\n"
                        end

                        BOT.pm_channel(_reaction_event.message.author.id).send_embed do |_embed|
                            _embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://i.gifer.com/2RnT.gif")
                            _embed.title = "Parabéns! Seu esforço foi notado!"
                            _embed.description = "De maneira **recente** você teve algum roleplay _**aprovado**_. É com grande prazer que eu te dou meus **parabéns** por seu esforço em tentar fazer à diferença. Se nos permite, gostariamos de **acrescentar** em sua evolução de alguma forma portanto recomendaremos **tutoriais** de edição abaixo e **conteúdo relevante**."
                            _embed.colour = "#FF0000"  #  Coloração vermelha para o embed.


                            _embed.add_field(name: "```Português é essencial!```", value: "É **óbvio** que todos entendemos o que a pessoa quer dizer mesmo se comete erros simplórios mas devemos **sempre** prezar pela excelência. Acesse o link ao lado e se atualize: _https://bit.ly/3cCRmnY_", inline: true)
                            _embed.add_field(name: "```Você está em busca de ser o próximo Escobar?```", value: "Você quer ser o próximo _**Escobar**_? Ou talvez sua interpretação seja mais simples como um ladrão de veículos que se associa a outros criminosos por proteção, não importa. **Qualquer que seja** o contexto esse tutorial é muito relevante: _https://bit.ly/3cDzr0x_")
                            _embed.add_field(name: "```Você é um bom policial ou precisaremos conversar em binário?```", value: "A facção mais importante do servidor **não é perfeita**, **todos** sabemos, então se você é um **iniciante** e foi acolhido por essa facção saiba que **você carrega o peso da responsabilidade de ter que manter um bom nível interpretativo**, ou você é danoso ao cenário do servidor. Um membro ruim de uma facção policial tem mais potencial destrutivo que membros ruins de qualquer outra facção, sabia? Se você ainda não viu esse artigo corre lá!: _https://bit.ly/3cDzr0x_")
                        end

                        BOT.pm_channel(_reaction_event.message.author.id).send_embed do |_new_embed|
                            _new_embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: BOT.bot_user.avatar_url)
                            _new_embed.title = "Aqui estão os links para sua futura postagem:"
                            _new_embed.description = "Você se esforcou bastante nesses últimos roleplays, não é mesmo? Estou torcendo para que você seja reconhecido e que não encontre nenhum guardinha de roleplay no futuro."
                            _new_embed.colour = "#FF0000"  #  Coloração vermelha para o embed.

                            _new_embed.add_field(name: "Links para adição ao fórum:", value: "```#{links_of_message}```")
                        end


                    elsif _reaction_event.emoji.name == "✅"
                        CONN.exec("UPDATE MEMBERS SET TOTAL_SCREENS_RATED = (TOTAL_SCREENS_RATED + 1) WHERE MEMBER_ID = #{_reaction_event.message.author.id};")
                        CONN.exec("UPDATE MEMBERS SET SCREENS_RATED_ACCEPT = (SCREENS_RATED_ACCEPT + 1) WHERE MEMBER_ID = #{_reaction_event.message.author.id};")

                    elsif _reaction_event.emoji.name == "❎"
                        CONN.exec("UPDATE MEMBERS SET TOTAL_SCREENS_RATED = (TOTAL_SCREENS_RATED + 1) WHERE MEMBER_ID = #{_reaction_event.message.author.id};")
                        CONN.exec("UPDATE MEMBERS SET SCREENS_RATED_REJECT = (SCREENS_RATED_REJECT + 1) WHERE MEMBER_ID = #{_reaction_event.message.author.id};")
                    else
                        _reaction_event.message.delete_reaction(_reaction_event.user.id, _reaction_event.emoji.name)
                    end
                else
                    _reaction_event.message.delete_reaction(_reaction_event.user.id, _reaction_event.emoji.name)
                end

            end

        end
    end
end
