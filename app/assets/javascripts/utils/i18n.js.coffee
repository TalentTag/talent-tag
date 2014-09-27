I18n.locale = I18n.default_locale = 'ru'

I18n.pluralizationRules =
  ru: (n) ->
    return "one" if n%10 == 1 && n%100 != 11 
    return "few" if [2, 3, 4].indexOf(n % 10) >= 0 && [12, 13, 14].indexOf(n % 100) < 0
    "other"

I18n.translate = (phrase, params, determiner=null) ->
  if _.isEmpty params
    I18n.t phrase
  else
    determiner ?= _.keys(params)[0]
    translation = I18n.t I18n.pluralizationRules[I18n.locale](params[determiner]), _.extend(params, scope: phrase)
    if translation.indexOf("[missing") is -1 then translation else I18n.t(phrase, _.omit(params, 'scope'))
