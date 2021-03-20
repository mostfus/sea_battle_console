//
//  Message.swift
//  Sea_battle
//
//  Created by Torpheus on 13.03.2021.
//

import Foundation

// contain all message for user

// если вы стреляете в зону куда не имеет смысла стрелять (отмечена так то) вы теряете ход

enum Message: String {
    case firstLaunch = "запуск", rules = "правила", commands = "команды", errorCommand = "ошибка ввода",
         setting = "настройки", legend = "легенда", endGame = "конец игры", win = "победа", lose = "поражение",
         battleshipDead = "Линкор", cruiserDead = "Крейсер", destroyerDead = "Эсминец", boatDead = "Катер", reShot = "повторный выстрел",
         wounded = "попадание"
    // добавить фразы при выстреле и попадании и тд, мимо
    
    // фраза при которой выходит за диапозон поля ! Туда стрелять не имеет смысла там молоко
    
    // для попаданий убийств и промахов можно добавить несколько вариантов ответов, рандомно
    
    var randomNum: Int {
        return Int.random(in: 1...4)
    }
    
    var description: String {
        switch self {
        case .firstLaunch:
            return """

Добро пожаловать в симулятор морского боя!

Одна из первых бумажных игр в которые мы все любили играть на уроках, переменах или просто в свободное время с друзьями.
Вам предстает возможность стать настоящим Адмиралом морского флота и победить противника!
"""
        case .rules:
            return """

После начала боя вы увидите два игровых поля. Слева будет ваше поле, справа – противника.

Вы будете по очереди стрелять по чужому полю вводя координаты. Если у соперника по этим координатам имеется корабль,
то корабль или его часть будет потоплена, а попавший получает право сделать ещё один ход, пока не промажет.

Ваша цель — первым потопить все корабли противника.

Возможные обозначения на поле:

"🟦" - облать доступная для обстрела
"⚪️" - промах
"❎" - палуба коробля
"🟠" - палуба получившая ранение
"❌" - корабль уничтожен
"🌀" - область, стрелять в которую не имеет смысла

Вы теряете ход если стреляете повторно в одну точку, кроме "🟦"
"""
        case .commands:
            return """

Доступные команды:

commands - команды
start - начать битву
rules - правила игры
b 5, B 5 - координаты для выстрела
exit - выход
"""
        case .errorCommand:
            return """
Адмирал, я не понимаю этой команды!

Попробуйте - b 5, B 5 или посмотрите доступные команды - commands
"""
        case .legend:
            switch randomNum {
            case 1:
                return """

Адмирал, вот сведения поступившие от командования:

"Атакована база Тихоокеанского флота и штаб-квартира России на Ляодунском полуострове (Китай).
 Отряд японских миноносцев атаковал наш флот на внешнем рейде Порт-Артура.
 Однако высадить десанты японцам пока не удалось.

 Ваша задача уничтожить силы противника наступающие с моря и предотвратить захват Крепости.

 Удачи!"
"""
            case 2:
                return """

Адмирал, вот сведения поступившие от командования:

"Наши криптографы взломали японский военно-морской код JN-25 и теперь нам известно о готовящейся
 японцами операции, включая точное место удара и состав атакующих сил.

 Вам необходимо занять оборону вблизи Атолл Мидуэй, расположенной в центральной части Тихого океана,
 к северо-западу от Гавайских островов. 16 сухопутных бомбардировщиков В-25В Mitchell подполковника
 Джеймса Дулиттла смогут обеспечить вам прикрытие.

 Ваша задача не допустить захвата этой стратегически важной зоны.

 Удачи!"
"""
            case 3:
                return """

Адмирал, вот сведения поступившие от командования:

"Для наших конвоев с подкреплениями направляющихся к Суэцкому каналу представляют угрозу турецкие корабли,
 находящиеся в Бейруте. Поэтому для решения этой проблемы командование итальянским флотом решило направить
 корабли под вашим командованием для уничтожения турецкой угрозы.

 Ваша задача уничтожить боевые корабли противника, а также несколько невооружённых транспортных судов.

 Удачи!"
"""
            default:
                return """

Адмирал, вот сведения поступившие от командования:

"Получены разведданные о том, что Аргентина планирует захват Фолклендских островов.
 Это стратегически важный объект для Великобритании, мы не можем идти на какие-либо уступки.

 Ваша задача защитить Фолклендские острова и предотвратить высадку сухопутных войск противника.

 Удачи!"
"""
            }
        case .setting:
            return """

Для корректного оторбражения поля, перед началом игры проверьте настройки терминала.

Откройте настройки терминала (вкладка предпочтения/Preferences), далее перейдите в профили/Profiles. Во вкладке текст/Text,
в подразделе шрифт/Font нажмите кнопку изменить/Change.

Установите рекомендуемые значения для следующих параметров:

межсимвольный интервал/Character Spacing - 1
межстрочный интервал/Line Spacing - 1,5
"""
        case .win:
            return """

Враг отступает – это победа!

Противник был силен, но мы верили в вас до конца, Адмирал.

Поступили новые данные, враг снова наступает. Необходимо направить флот на помощь союзнику.
Вы готовы вступить в новую битву?

Для продолжения введите – start, чтобы закончить игру – exit.
"""
        case .lose:
            return """

Адмирал, все наши корабли потоплены, мы вынуждены отступить.

Битва проиграна, но вайна еще нет! Штаб готов предоставить новый флот, чтобы отстоять рубеж.
Вы готовы вступить в новую битву?

Для продолжения введите – start, чтобы закончить игру – exit.
"""
        case .endGame:
            return """

Для нас была честь служить вам!
До встречи в следующих сражениях.

"""
        case .battleshipDead, .cruiserDead, .destroyerDead, .boatDead:
            switch randomNum {
            case 1:
                return """

Вражеский \(self.rawValue.lowercased()) потоплен
"""
            case 2:
                return """

Вражеский \(self.rawValue.lowercased()) уничтожен
"""
            case 3:
                return """

\(self.rawValue) врага потоплен
"""
            default:
                return """

\(self.rawValue) противника уничтожен
"""
            }
        case .reShot:
            return """

Мы уже атаковали эту зону! Сюда не имеет смысла стрелять
"""
        case .wounded:
            switch randomNum {
            case 1:
                return """

Пробитие подтверждаю!
"""
            case 2:
                return """

Меткое попадание!
"""
            case 3:
                return """

Есть пробитие!
"""
            default:
                return """

Пробитие!
"""
            }
        }
    }
}