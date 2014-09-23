@talent.directive "ttShortProfile", ->

  templateUrl: '/assets/widgets/short_profile.html.slim'
  scope: { author: "=ttShortProfile" }

  link: (scope, elem, attrs) ->
    scope.name    = scope.author.name
    scope.url     = scope.author.url
    scope.profile = scope.author.profile

    scope.schools = scope.profile.schools.map (school) ->
      str = (school.type_str || "Средняя школа") + " " + school.name
      str += ", г.#{ school.city }" if school.city?
      str += " (#{ school.year_from }-#{ school.year_to } гг.)" if school.year_from? and school.year_to?
      str

    scope.universities = scope.profile.universities.map (university) ->
      str = university.name
      str += " г.#{ university.city }" if university.city?
      str += ", факультет #{ university.faculty_name }" if university.faculty_name?
      str += ", кафедра #{ university.chair_name }" if university.chair_name?
      str += ", #{ university.education_form }" if university.education_form?
      str += " (выпуск #{ university.graduation }г.)" if university.graduation?

