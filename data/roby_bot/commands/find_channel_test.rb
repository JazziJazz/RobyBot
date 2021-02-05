module RobyBot
    module Commands
        module FindChannel
            extend Discordrb::Commands::CommandContainer
            extend RobyBot::MyOwnFunctions

            command(:canal_create) do |_event|
                create_embed(_event, "💻roby-propaganda")
            end

            command(:canal_remove) do |_event|
                remove_embed(_event, "💻roby-propaganda")
            end

            command(:canal_update) do |_event|
                update_embed(_event, "💻roby-propaganda")
            end

        end
    end
end
