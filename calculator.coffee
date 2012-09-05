class NumberFormat
  this.format = (number, decimals = 0, dec_point = ',', thousands_sep = ' ') ->
    negative = if number < 0 then '-' else ''
    number = Math.abs number
    decimal = ((number - parseInt number).toFixed decimals)[2..]
    number = "#{parseInt number.toFixed decimals}".split('').reverse().join('').
    replace(/...(?!$)/g, "$&#{thousands_sep.replace /\$/g, '$$$$'}").
    split('').reverse().join('')
    decimalPoint = if decimals isnt 0 then dec_point else ''
    "#{negative}#{number}#{decimalPoint}#{decimal}"

class Calculator
  constructor: ->
    this.make_select_issue_value()
    this.make_select_pay_period()

  make_select_issue_value: ->
    select_issue_value = $("select[name='issue-value']")
    for value in [1000..50000] by 1000
      select_issue_value.append($("<option value=#{value}>#{NumberFormat.format(value)} Kč</option>"))

  make_select_pay_period: ->
    select_pay_period = $("select[name='pay-period']")
    for value in ['45 týdnů', '60 týdnů']
      select_pay_period.append($("<option value=#{value}>#{value}</option>"))

jQuery ->
  new Calculator()
