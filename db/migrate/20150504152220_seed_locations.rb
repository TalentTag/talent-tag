class SeedLocations < ActiveRecord::Migration
  LOCATION_DATA = [
    {
      name: 'Москва',
      synonyms: ['Москва', 'МОСКВА', 'Москва', 'Россия, Москва', 'москва', 'Moscow', 'Moscow, Russia',
        'Moscow, Russian Federation, RU', 'мск']
    },
    {
      name: 'Санкт-Петербург',
      synonyms: ['Санкт-Петербург', 'Россия, Санкт-Петербург', 'СПб', 'Питер', 'Saint Petersburg', 'Saint P.',
        'Saint Petersburg, Russia', 'Saint Petersburg, Russian Federation, RU', 'спб']
    },
    {
      name: 'Новосибирск',
      synonyms: ['Новосибирск', 'Новосибирская область', 'Новосиб', 'Novosibirsk, Russia']
    },
    {
      name: 'Минск',
      synonyms: ['Минск', 'минск', 'Беларусь, Минск', 'Minsk, Belarus']
    },
    {
      name: 'Люберцы',
      synonyms: ['Люберцы']
    },
    {
      name: 'Магнитогорск',
      synonyms: ['Магнитогорск']
    },
    {
      name: 'Прага',
      synonyms: ['Praha', 'прага', 'Прага']
    },
    {
      name: 'Алма-Ата',
      synonyms: ['Алма-Ата', 'Алматы']
    },
    {
      name: 'Витебск',
      synonyms: ['Витебск']
    },
    {
      name: 'Вологда',
      synonyms: ['Вологда']
    },
    {
      name: 'Екатеринбург',
      synonyms: ['Екатеринбург', 'Россия, Екатеринбург', 'Екат', 'екб']
    },
    {
      name: 'Воронеж',
      synonyms: ['Воронеж', 'Россия, Воронеж', 'Воронежская область']
    },
    {
      name: 'New York',
      synonyms: ['New York', 'New York City']
    },
    {
      name: 'London',
      synonyms: ['London', 'Лондон']
    },
    {
      name: 'Запорожье',
      synonyms: ['Запорожье', 'Украина, Запорожье']
    },
    {
      name: 'Зеленоград',
      synonyms: ['Зеленоград']
    },
    {
      name: 'Казань',
      synonyms: ['Казань', 'Kazan']
    },
    {
      name: 'Калининград',
      synonyms: ['Калининград', 'Россия, Калининград', 'г. Калининград (Калининградская область)', 'Калининградская область']
    },
    {
      name: 'Калуга',
      synonyms: ['Калуга', 'Калуга-2', 'Калужская область']
    },
    {
      name: 'Красноярск',
      synonyms: ['Красноярск', 'krsk']
    },
    {
      name: 'Киев',
      synonyms: ['Киев', 'Украина, Киев', 'Kyiv, Ukraine']
    },
    {
      name: 'Магнитогорск',
      synonyms: ['Магнитогорск']
    },
    {
      name: 'Наро-Фоминск',
      synonyms: ['Наро-Фоминск']
    },
    {
      name: 'Нижний Новгород',
      synonyms: ['Нижний Новгород']
    },
    {
      name: 'Омск',
      synonyms: ['Омск']
    },
    {
      name: 'Ростов-на-Дону',
      synonyms: ['Ростов-на-Дону', 'ростов-на-дону']
    },
    {
      name: 'Ярославль',
      synonyms: ['Ярославль']
    }
  ]

  def up
    LOCATION_DATA.each do |record|
      Location.where(name: record[:name]).first_or_create.tap do |location|
        location.update_attributes synonyms: (location.synonyms || []).to_set.merge(record[:synonyms]).to_a
      end
    end
  end

  def down
    p 'Irreversible'
  end
end
