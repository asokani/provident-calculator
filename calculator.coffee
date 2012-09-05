class NumberFormat
  this.format = (number, decimals = 0, dec_point = ',', thousands_sep = ' ') ->
    # from https://github.com/GlitchMr/number-format/blob/master/lib/number-format.coffee
    negative = if number < 0 then '-' else ''
    number = Math.abs number
    decimal = ((number - parseInt number).toFixed decimals)[2..]
    number = "#{parseInt number.toFixed decimals}".split('').reverse().join('').
    replace(/...(?!$)/g, "$&#{thousands_sep.replace /\$/g, '$$$$'}").
    split('').reverse().join('')
    decimalPoint = if decimals isnt 0 then dec_point else ''
    "#{negative}#{number}#{decimalPoint}#{decimal}"

class Computation
  table: {}
  table_string: """
    issue_value	apr_45	interest_45	instalment_45	fee_45			apr_60	interest_60	instalment_60	fee_60
    4000	70,93	381	112	640			-	-	-	-
    5000	70,93	477	140	800			-	-	-	-
    6000	70,93	572	168	960			63,91	766	132	1140
    7000	70,93	668	196	1120			63,91	894	154	1330
    8000	70,93	763	224	1280			63,91	1021	176	1520
    9000	70,93	858	252	1440			63,91	1149	198	1710
    10000	70,93	954	279	1600			63,91	1277	220	1900
    11000	70,93	1049	307	1760			63,91	1405	242	2090
    12000	70,93	1144	335	1920			63,91	1532	264	2280
    13000	70,93	1240	363	2080			63,91	1660	286	2470
    14000	70,93	1335	391	2240			63,91	1788	308	2660
    15000	70,93	1430	419	2400			63,91	1915	330	2850
    16000	70,93	1526	447	2560			63,91	2043	352	3040
    17000	70,93	1621	475	2720			63,91	2171	374	3230
    18000	70,93	1716	503	2880			63,91	2298	396	3420
    19000	70,93	1812	531	3040			63,91	2426	418	3610
    20000	70,93	1907	558	3200			63,91	2554	440	3800
    21000	70,93	2003	586	3360			63,91	2681	462	3990
    22000	70,93	2098	614	3520			63,91	2809	484	4180
    23000	70,93	2193	642	3680			63,91	2937	506	4370
    24000	70,93	2289	670	3840			63,91	3064	528	4560
    25000	70,93	2384	698	4000			63,91	3192	550	4750
    26000	70,93	2479	726	4160			63,91	3320	571	4940
    27000	70,93	2575	754	4320			63,91	3448	593	5130
    28000	70,93	2670	782	4480			63,91	3575	615	5320
    29000	70,93	2765	809	4640			63,91	3703	637	5510
    30000	70,93	2861	837	4800			63,91	3831	659	5700
    31000	70,93	2956	865	4960			63,91	3958	681	5890
    32000	70,93	3051	893	5120			63,91	4086	703	6080
    33000	70,93	3147	921	5280			63,91	4214	725	6270
    34000	70,93	3242	949	5440			63,91	4341	747	6460
    35000	70,93	3338	977	5600			63,91	4469	769	6650
    36000	70,93	3433	1005	5760			63,91	4597	791	6840
    37000	70,93	3528	1033	5920			63,91	4724	813	7030
    38000	70,93	3624	1061	6080			63,91	4852	835	7220
    39000	70,93	3719	1088	6240			63,91	4980	857	7410
    40000	70,93	3814	1116	6400			63,91	5107	879	7600
    41000	-	-	-	-			63,91	5235	901	7790
    42000	-	-	-	-			63,91	5363	923	7980
    43000	-	-	-	-			63,91	5490	945	8170
    44000	-	-	-	-			63,91	5618	967	8360
    45000	-	-	-	-			63,91	5746	989	8550
    46000	-	-	-	-			63,91	5874	1011	8740
    47000	-	-	-	-			63,91	6001	1033	8930
    48000	-	-	-	-			63,91	6129	1055	9120
    49000	-	-	-	-			63,91	6257	1077	9310
    50000	-	-	-	-			63,91	6384	1099	9500
  """

  constructor: ->
    counter = 0
    for row in @table_string.split("\n")
      columns = row.replace(/^\s+|\s+$/g, "").split("\t")
      if counter == 0
        @header = columns
      else
        @table[this.get_value(columns, "issue_value")] = {}
        for week in [45, 60]
          @table[this.get_value(columns, "issue_value")][week] = {
            apr: this.get_value(columns, "apr_" + week),
            interest:  this.get_value(columns, "interest_" + week),
            instalment:  this.get_value(columns, "instalment_" + week),
            fee:  this.get_value(columns, "fee_" + week)
          }
      counter++

  get_value: (columns, name) ->
    value = columns[$.inArray(name, @header)].replace(",", ".")
    if value != "-"
      return parseFloat(value)
    return value

  get_allowed_weeks: (issue_value) ->
    weeks = []
    for week in [45, 60]
      if @table[issue_value][week]["apr"] != "-"
        weeks.push(week)
    return weeks

  compute: (issue_value, pay_period) ->
    @table[issue_value][pay_period]

jQuery ->
  class Calculator
    select_issue_value: $("select[name='issue-value']")
    select_pay_period: $("select[name='pay-period']")
    instalment: $("#instalment")
    total: $("#total")
    apr: $("#apr")
    computation: new Computation()

    constructor: ->
      @select_issue_value.change(this.redraw)
      @select_pay_period.change(this.recalculate)
      this.make_select_issue_value()
      this.make_select_pay_period()
      this.recalculate()

    make_select_issue_value: ->
      for value in [4000..50000] by 1000
        selected = if value == 25000 then "selected='selected'" else ''
        @select_issue_value.append($("<option value=#{value} #{selected}>#{NumberFormat.format(value)} Kč</option>"))

    make_select_pay_period: (weeks = [45, 60]) ->
      @select_pay_period.empty()
      for value in weeks
        @select_pay_period.append($("<option value=#{value}>#{value} týdnů</option>"))

    redraw: =>
      issue_value = @select_issue_value.val()
      this.make_select_pay_period(@computation.get_allowed_weeks(issue_value))
      this.recalculate();

    recalculate: =>
      issue_value = parseFloat(@select_issue_value.val())
      issue = @computation.compute(issue_value, @select_pay_period.val())
      @instalment.html(NumberFormat.format(issue.instalment) + " Kč")
      @total.html(NumberFormat.format(issue_value + issue.interest + issue.fee) + " Kč")
      @apr.html(NumberFormat.format(issue.apr, 2) + " %")

  new Calculator()

