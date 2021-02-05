module RobyBot
    module Commands
        module DeleteChatTeste
            extend Discordrb::Commands::CommandContainer

            command(:delety) do |event|
                channels_to_delete = CONN.exec("SELECT CHANNEL_ID FROM CHANNELS WHERE SERVER_ID = #{event.server.id} AND CHANNEL_NAME = '💎roby channels' OR CHANNEL_NAME = '🤖roby-comandos' OR CHANNEL_NAME = '💻roby-propaganda' OR CHANNEL_NAME = '🧙♂roby-av-screenshots';").values

                channels_to_delete.each do |server_id|
                    sleep(0.5)
                    BOT.channel(server_id[0].to_i, event.server).delete
                end
            end
        end
    end
end

