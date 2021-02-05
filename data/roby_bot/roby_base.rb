module RobyBot
    configuration = JSON.parse(File.read('/home/rodrigosc/RubymineProjects/roby-bot/data/roby_bot/configuration-roby-bot.json'))
    BOT = Discordrb::Commands::CommandBot.new(token: configuration['token_id'], prefix: configuration['prefix'], advanced_functionality: false)
    CONN = PG.connect(dbname: 'Roby', user: 'obscure', password: 'Roodrigoo123!@#!@#')

    BOT.bucket(:roasted, delay: 3000)

    #  Área de inclusões de módulos personalizados; Commands.
    BOT.include! Commands::Ping
    BOT.include! Commands::Information
    BOT.include! Commands::CreateChatTeste
    BOT.include! Commands::DeleteChatTeste
    BOT.include! Commands::CommandTest
    BOT.include! Commands::FindChannel

    #  Área de inclusões de módulos personalizados; Events.
    BOT.include! Events::OnEnterServer
    BOT.include! Events::OnExitServer
    BOT.include! Events::PowerOnBot
    BOT.include! Events::OnMessageAttachment
    BOT.include! Events::OnRatedRoleplay
    BOT.include! Events::OnPlayerEnter
    BOT.include! Events::OnPlayerExit
    BOT.include! Events::OnPlayerUpdate

    #  Área de inicialização do bot.
    BOT.run
end
