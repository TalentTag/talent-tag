tt = Company.create \
  name:     "TalentTag",

  website:  "http://talent-tag.ru",
  phone:    "+7(999)5555-1234",
  address:  "г. Москва",
  details:  "some_details",

  owner_attributes: {
    email:                  "tt@local.host",
    password:               "123456",
    password_confirmation:  "123456",

    firstname:  "Семен",
    midname:    "Иванович",
    lastname:   "Носов",
    phone:      "+7(999)5555-5678"
  },

  confirmed_at: Date.today

tt.owner.update role: :admin
