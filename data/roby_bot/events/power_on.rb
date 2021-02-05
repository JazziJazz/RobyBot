module RobyBot
    module Events
        module PowerOnBot
            extend Discordrb::EventContainer
            ready do |informations|
                print 'Bot is ready'

                scheduler = Rufus::Scheduler.new

                BOT.servers.each do |server|
                    BOT.server(server[0]).channels.each do |channel|
                        if channel.name == '💻roby-propaganda';
                            scheduler.every '10m' do
                                BOT.send_message(channel.id, 'Propaganda automática, baby.')
                            end
                        end

                        if channel.name == "🤖roby-comandos";
                            BOT.add_await!(Discordrb::Events::ReactionAddEvent, emoji: "✅") do |_event|
                                _event.respond "Funcional."
                                next true
                            end

                            print("É o teste.")
                        end
                    end

                end


            end
        end
    end
end
