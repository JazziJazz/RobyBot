require 'discordrb'
require 'pg'
require 'rufus-scheduler'

module RobyBot
    #  Basicamente, aqui estamos requerendo todo arquivo que tenha a extensão .rb dentro das pastas commands e events em roby_bot.
    Dir["#{File.dirname(__FILE__)}/roby_bot/functions/*.rb"].each { |file| require file }
    Dir["#{File.dirname(__FILE__)}/roby_bot/commands/*.rb"].each { |file| require file }
    Dir["#{File.dirname(__FILE__)}/roby_bot/events/*.rb"].each { |file| require file }


    #  Requirir o arquívo de base é extremamente importante, nele é salvo toda a configuração do bot.
    require_relative 'roby_bot/roby_base'
end