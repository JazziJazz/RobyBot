module RobyBot
    module Commands
        module Ping
            extend Discordrb::Commands::CommandContainer
            command(:pact, description: 'Responds with respond time') do |event|
                my_channel = BOT.find_channel("🤖roby-comandos", event.server.name)
                my_table = []

                BOT.add_await!(Discordrb::Events::ReactionAddEvent, emoji: '✅', timeout: 15) do |reaction_event|
                    my_table.push(reaction_event.message.content)
                end

                my_table.each {|content| BOT.send_message(my_channel[0].id, content)}
            end
        end
    end
end
