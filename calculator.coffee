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
    issue_value	apr_45	interest_45	instalment_45	instalment_last_45	fee_45	rate_45						apr_60	interest_60	instalment_last_60	instalment_60	fee_60	rate_60
    4000	70,93	381	112	93	640	20,108						-	-	-	-	-	-
    5000	70,93	477	140	117	800	20,108						-	-	-	-	-	-
    6000	70,93	572	168	140	960	20,108						63,91	766	118	132	1140	19,9753
    7000	70,93	668	196	164	1120	20,108						63,91	894	138	154	1330	19,9753
    8000	70,93	763	224	187	1280	20,108						63,91	1021	157	176	1520	19,9753
    9000	70,93	858	252	210	1440	20,108						63,91	1149	177	198	1710	19,9753
    10000	70,93	954	279	278	1600	20,108						63,91	1277	197	220	1900	19,9753
    11000	70,93	1049	307	301	1760	20,108						63,91	1405	217	242	2090	19,9753
    12000	70,93	1144	335	324	1920	20,108						63,91	1532	236	264	2280	19,9753
    13000	70,93	1240	363	348	2080	20,108						63,91	1660	256	286	2470	19,9753
    14000	70,93	1335	391	371	2240	20,108						63,91	1788	276	308	2660	19,9753
    15000	70,93	1430	419	394	2400	20,108						63,91	1915	295	330	2850	19,9753
    16000	70,93	1526	447	418	2560	20,108						63,91	2043	315	352	3040	19,9753
    17000	70,93	1621	475	441	2720	20,108						63,91	2171	335	374	3230	19,9753
    18000	70,93	1716	503	464	2880	20,108						63,91	2298	354	396	3420	19,9753
    19000	70,93	1812	531	488	3040	20,108						63,91	2426	374	418	3610	19,9753
    20000	70,93	1907	558	555	3200	20,108						63,91	2554	394	440	3800	19,9753
    21000	70,93	2003	586	579	3360	20,108						63,91	2681	413	462	3990	19,9753
    22000	70,93	2098	614	602	3520	20,108						63,91	2809	433	484	4180	19,9753
    23000	70,93	2193	642	625	3680	20,108						63,91	2937	453	506	4370	19,9753
    24000	70,93	2289	670	649	3840	20,108						63,91	3064	472	528	4560	19,9753
    25000	70,93	2384	698	672	4000	20,108						63,91	3192	492	550	4750	19,9753
    26000	70,93	2479	726	695	4160	20,108						63,91	3320	571	571	4940	19,9753
    27000	70,93	2575	754	719	4320	20,108						63,91	3448	591	593	5130	19,9753
    28000	70,93	2670	782	742	4480	20,108						63,91	3575	610	615	5320	19,9753
    29000	70,93	2765	809	809	4640	20,108						63,91	3703	630	637	5510	19,9753
    30000	70,93	2861	837	833	4800	20,108						63,91	3831	650	659	5700	19,9753
    31000	70,93	2956	865	856	4960	20,108						63,91	3958	669	681	5890	19,9753
    32000	70,93	3051	893	879	5120	20,108						63,91	4086	689	703	6080	19,9753
    33000	70,93	3147	921	903	5280	20,108						63,91	4214	709	725	6270	19,9753
    34000	70,93	3242	949	926	5440	20,108						63,91	4341	728	747	6460	19,9753
    35000	70,93	3338	977	950	5600	20,108						63,91	4469	748	769	6650	19,9753
    36000	70,93	3433	1005	973	5760	20,108						63,91	4597	768	791	6840	19,9753
    37000	70,93	3528	1033	996	5920	20,108						63,91	4724	787	813	7030	19,9753
    38000	70,93	3624	1061	1020	6080	20,108						63,91	4852	807	835	7220	19,9753
    39000	70,93	3719	1088	1087	6240	20,108						63,91	4980	827	857	7410	19,9753
    40000	70,93	3814	1116	1110	6400	20,108						63,91	5107	846	879	7600	19,9753
    41000	-	-	-	-	-	-						63,91	5235	866	901	7790	19,9753
    42000	-	-	-	-	-	-						63,91	5363	886	923	7980	19,9753
    43000	-	-	-	-	-	-						63,91	5490	905	945	8170	19,9753
    44000	-	-	-	-	-	-						63,91	5618	925	967	8360	19,9753
    45000	-	-	-	-	-	-						63,91	5746	945	989	8550	19,9753
    46000	-	-	-	-	-	-						63,91	5874	965	1011	8740	19,9753
    47000	-	-	-	-	-	-						63,91	6001	984	1033	8930	19,9753
    48000	-	-	-	-	-	-						63,91	6129	1004	1055	9120	19,9753
    49000	-	-	-	-	-	-						63,91	6257	1024	1077	9310	19,9753
    50000	-	-	-	-	-	-						63,91	6384	1043	1099	9500	19,9753
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
            instalment_last:  this.get_value(columns, "instalment_last_" + week),
            fee:  this.get_value(columns, "fee_" + week),
            rate:  this.get_value(columns, "rate_" + week)
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

class Tooltip
  constructor: (event) ->
    target = $(event.target)
    target_position = target.offset()
    body_width = $("body").width()
    body_height = $("body").height()
    @name = target.attr("data-type")
    @layer = $(".tooltip[data-type=#{@name}]")

    layer_padding = 5
    distance = 5
    top = target_position.top
    bottom = body_height - top - target.height()
    left = target_position.left
    right = body_width - left - target.width();
    if left > right
      layer_width = left - (distance*2 + layer_padding*2)
      layer_left = left - (layer_width + layer_padding*2) - distance
    else
      layer_width = right - (distance*2 + layer_padding*2)
      layer_left = target_position.left + distance + target.width()
    @layer.css({
      left: layer_left,
      width: layer_width
    })
    if top > bottom
      layer_top = target_position.top - @layer.height() + 3
    else
      layer_top = target_position.top
    @layer.css({top: layer_top})
    @layer.show()

  out: =>
    @layer.hide()


jQuery ->
  class Calculator
    select_issue_value: $("select[name='issue-value']")
    select_pay_period: $("select[name='pay-period']")
    instalment: $("#instalment")
    total: $("#total")
    apr: $("#apr")
    fee: $("#fee")
    interest: $("#interest")
    rate: $("#rate")
    instalment_last: $("#instalment-last")
    fees: $("#fees")

    computation: new Computation()

    constructor: ->
      @select_issue_value.change(this.redraw)
      @select_pay_period.change(this.recalculate)
      this.make_select_issue_value()
      this.make_select_pay_period()
      this.recalculate()

      $(".question").mouseover(this.tooltip_over)
      $(".question").mouseout(this.tooltip_out)

    make_select_issue_value: ->
      for value in [4000..50000] by 1000
        selected = if value == 18000 then "selected='selected'" else ''
        @select_issue_value.append($("<option value=#{value} #{selected}>#{NumberFormat.format(value)} Kč</option>"))

    make_select_pay_period: (weeks = [45, 60]) ->
      @select_pay_period.empty()
      for value in weeks
        selected = if value == 60 then "selected='selected'" else ''
        @select_pay_period.append($("<option value=#{value} #{selected}>#{value} týdnů</option>"))

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
      @fee.html(NumberFormat.format(issue.fee) + " Kč")
      @interest.html(NumberFormat.format(issue.interest) + " Kč")
      @rate.html(NumberFormat.format(issue.rate, 3) + " %")
      @instalment_last.html(NumberFormat.format(issue.instalment_last) + " Kč")
      @fees.html(NumberFormat.format(issue.interest + issue.fee) + " Kč")

    tooltip_over: (event) =>
      @current_tooltip = new Tooltip(event)

    tooltip_out: (event) =>
      @current_tooltip.out()


  new Calculator()



