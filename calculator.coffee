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
  issue_value	apr_45	fee_45	interest_45	fee_admin_45	fee_cash_45	total_45	total_pay_45	instalment_45	instalment_last_45	apr_60	fee_60	interest_60	fee_admin_60	fee_cash_60	total_60	total_pay_60	instalment_60	instalment_last_60	apr_100	fee_100	interest_100	fee_admin_100	fee_cash_100	total_100	total_pay_100	instalment_100	instalment_last_100
    80000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	35346	16582	18764	-	115346	115346	1154	1100
    78000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	34462	16167	18295	-	112462	112462	1125	1087
    76000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	33578	15753	17825	-	109578	109578	1096	1074
    74000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	32695	15338	17357	-	106695	106695	1067	1062
    72000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	31811	14924	16887	-	103811	103811	1039	950
    70000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	30927	14509	16418	-	100927	100927	1010	937
    68000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	30044	14095	15949	-	98044	98044	981	925
    66000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	29160	13680	15480	-	95160	95160	952	912
    64000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	28277	13266	15011	-	92277	92277	923	900
    62000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	27393	12851	14542	-	89393	89393	894	887
    60000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	26509	12436	14073	-	86509	86509	866	775
    58000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	25626	12022	13604	-	83626	83626	837	763
    56000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	24742	11607	13135	-	80742	80742	808	750
    54000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	23858	11193	12665	-	77858	77858	779	737
    52000	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	49,70	22975	10778	12197	-	74975	74975	750	725
    50000	-	-	-	-	-	-	-	-	-	63,93	15888	6386	9502	-	65888	65888	1099	1047	49,70	22091	10364	11727	-	72091	72091	721	712
    49000	-	-	-	-	-	-	-	-	-	63,93	15570	6258	9312	-	64570	64570	1077	1027	-	-	-	-	-	-	-	-	-
    48000	-	-	-	-	-	-	-	-	-	63,93	15252	6130	9122	-	63252	63252	1055	1007	49,70	21207	9949	11258	-	69207	69208	693	600
    47000	-	-	-	-	-	-	-	-	-	63,93	14934	6002	8932	-	61934	61934	1033	987	-	-	-	-	-	-	-	-	-
    46000	-	-	-	-	-	-	-	-	-	63,93	14617	5875	8742	-	60617	60617	1011	968	49,70	20324	9535	10789	-	66324	66325	664	588
    45000	-	-	-	-	-	-	-	-	-	63,93	14299	5747	8552	-	59299	59299	989	948	-	-	-	-	-	-	-	-	-
    44000	-	-	-	-	-	-	-	-	-	63,93	13981	5619	8362	-	57981	57981	967	928	49,70	19440	9120	10320	-	63440	63441	635	575
    43000	-	-	-	-	-	-	-	-	-	63,93	13663	5492	8171	-	56663	56663	945	908	-	-	-	-	-	-	-	-	-
    42000	-	-	-	-	-	-	-	-	-	63,93	13346	5364	7982	-	55346	55346	923	889	49,70	18556	8705	9851	-	60556	60557	606	562
    41000	-	-	-	-	-	-	-	-	-	63,93	13028	5236	7792	-	54028	54028	901	869	-	-	-	-	-	-	-	-	-
    40000	70,96	10215	3815	6400	-	50215	50215	1116	1111	63,93	12710	5109	7601	-	52710	52710	879	849	49,70	17673	8291	9382	-	57673	57674	577	550
    39000	70,96	9959	3719	6240	-	48959	48959	1088	1087	63,93	12392	4981	7411	-	51392	51392	857	829	-	-	-	-	-	-	-	-	-
    38000	70,96	9704	3624	6080	-	47704	47704	1061	1020	63,93	12075	4853	7222	-	50075	50075	835	810	49,70	16789	7876	8913	-	54789	54790	548	537
    37000	70,96	9448	3528	5920	-	46448	46448	1033	996	63,93	11757	4726	7031	-	48757	48757	813	790	-	-	-	-	-	-	-	-	-
    36000	70,96	9193	3433	5760	-	45193	45193	1005	973	63,93	11439	4598	6841	-	47439	47439	791	770	49,70	15906	7462	8444	-	51906	51907	520	426
    35000	70,96	8938	3338	5600	-	43938	43938	977	950	63,93	11121	4470	6651	-	46121	46121	769	750	-	-	-	-	-	-	-	-	-
    34000	70,96	8682	3242	5440	-	42682	42682	949	926	63,93	10804	4342	6462	-	44804	44804	747	731	49,70	15022	7047	7975	-	49022	49023	491	413
    33000	70,96	8427	3147	5280	-	41427	41427	921	903	63,93	10486	4215	6271	-	43486	43486	725	711	-	-	-	-	-	-	-	-	-
    32000	70,96	8172	3052	5120	-	40172	40172	893	880	63,93	10168	4087	6081	-	42168	42168	703	691	49,70	14138	6633	7505	-	46138	46139	462	400
    31000	70,96	7916	2956	4960	-	38916	38916	865	856	63,93	9850	3959	5891	-	40850	40850	681	671	-	-	-	-	-	-	-	-	-
    30000	70,96	7661	2861	4800	-	37661	37661	837	833	63,93	9533	3832	5701	-	39533	39533	659	652	49,70	13255	6218	7037	-	43255	43256	433	388
    29000	70,96	7406	2766	4640	-	36406	36406	810	766	63,93	9215	3704	5511	-	38215	38215	637	632	-	-	-	-	-	-	-	-	-
    28000	70,96	7150	2670	4480	-	35150	35150	782	742	63,93	8897	3576	5321	-	36897	36897	615	612	49,70	12371	5804	6567	-	40371	40372	404	375
    27000	70,96	6895	2575	4320	-	33895	33895	754	719	63,93	8579	3448	5131	-	35579	35579	593	592	-	-	-	-	-	-	-	-	-
    26000	70,96	6639	2479	4160	-	32639	32639	726	695	63,93	8262	3321	4941	-	34262	34262	572	514	49,70	11487	5389	6098	-	37487	37488	375	362
    25000	70,96	6384	2384	4000	-	31384	31384	698	672	63,93	7944	3193	4751	-	32944	32944	550	494	-	-	-	-	-	-	-	-	-
    24000	70,96	6129	2289	3840	-	30129	30129	670	649	63,93	7626	3065	4561	-	31626	31626	528	474	49,70	10604	4975	5629	-	34604	34605	347	251
    23000	70,96	5873	2193	3680	-	28873	28873	642	625	63,93	7308	2937	4371	-	30308	30308	506	454	-	-	-	-	-	-	-	-	-
    22000	70,96	5618	2098	3520	-	27618	27618	614	602	63,93	6991	2810	4181	-	28991	28991	484	435	49,70	9720	4560	5160	-	31720	31721	318	238
    21000	70,96	5363	2003	3360	-	26363	26363	586	579	63,93	6673	2682	3991	-	27673	27673	462	415	-	-	-	-	-	-	-	-	-
    20000	70,96	5107	1907	3200	-	25107	25107	558	555	63,93	6355	2554	3801	-	26355	26355	440	395	49,70	8836	4145	4691	-	28836	28837	289	225
    19000	70,96	4852	1812	3040	-	23852	23852	531	488	63,93	6037	2426	3611	-	25037	25037	418	375	-	-	-	-	-	-	-	-	-
    18000	70,96	4597	1717	2880	-	22597	22597	503	465	63,93	5720	2299	3421	-	23720	23720	396	356	49,70	7953	3731	4222	-	25953	25954	260	213
    17000	70,96	4341	1621	2720	-	21341	21341	475	441	63,93	5402	2171	3231	-	22402	22402	374	336	-	-	-	-	-	-	-	-	-
    16000	70,96	4086	1526	2560	-	20086	20086	447	418	63,93	5084	2043	3041	-	21084	21084	352	316	49,70	7069	3316	3753	-	23069	23070	231	200
    15000	70,96	3830	1430	2400	-	18830	18830	419	394	63,93	4766	1916	2850	-	19766	19766	330	296	-	-	-	-	-	-	-	-	-
    14000	70,96	3575	1335	2240	-	17575	17575	391	371	63,93	4449	1788	2661	-	18449	18449	308	277	-	-	-	-	-	-	-	-	-
    13000	70,96	3320	1240	2080	-	16320	16320	363	348	63,93	4131	1660	2471	-	17131	17131	286	257	-	-	-	-	-	-	-	-	-
    12000	70,96	3064	1144	1920	-	15064	15064	335	324	63,93	3813	1533	2280	-	15813	15813	264	237	-	-	-	-	-	-	-	-	-
    11000	70,96	2809	1049	1760	-	13809	13809	307	301	63,93	3495	1405	2090	-	14495	14495	242	217	-	-	-	-	-	-	-	-	-
    10000	70,96	2554	954	1600	-	12554	12554	279	278	63,93	3178	1277	1901	-	13178	13178	220	198	-	-	-	-	-	-	-	-	-
    9000	70,96	2298	858	1440	-	11298	11298	252	210	63,93	2860	1150	1710	-	11860	11860	198	178	-	-	-	-	-	-	-	-	-
    8000	70,96	2043	763	1280	-	10043	10043	224	187	63,93	2542	1022	1520	-	10542	10542	176	158	-	-	-	-	-	-	-	-	-
    7000	70,96	1788	668	1120	-	8788	8788	196	164	63,93	2224	894	1330	-	9224	9224	154	138	-	-	-	-	-	-	-	-	-
    6000	70,96	1532	572	960	-	7532	7532	168	140	63,93	1907	766	1141	-	7907	7907	132	119	-	-	-	-	-	-	-	-	-
    5000	70,96	1277	477	800	-	6277	6277	140	117	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-
    4000	70,96	1021	381	640	-	5021	5021	112	93	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-	-
  """

  constructor: ->
    counter = 0
    for row in @table_string.split("\n")
      columns = row.replace(/^\s+|\s+$/g, "").split("\t")
      if counter == 0
        @header = columns
      else
        issue_value = this.get_value(columns, "issue_value")
        @table[issue_value] = {}
        for week in [45, 60, 100]
          @table[issue_value][week] = {}
          for column in ["apr", "fee", "interest", "fee_admin", "fee_cash", "total", "total_pay",
            "instalment", "instalment_last"]
            @table[issue_value][week][column] = this.get_value(columns, column + "_" + week)
          @table[issue_value][week]["interest_rate"] = if week == 45 then 20.11 else (if week == 60 then 19.98 else 19.00)
      counter++

  get_value: (columns, name) ->
    value = columns[$.inArray(name, @header)].replace(",", ".")
    if value != "-"
      return parseFloat(value)
    return value

  get_allowed_weeks: (issue_value) ->
    weeks = []
    for week in [45, 60, 100]
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
      for value in [52000..80000] by 2000
        @select_issue_value.append($("<option value=#{value}>#{NumberFormat.format(value)} Kč</option>"))
    make_select_pay_period: (weeks = [45, 60, 100]) ->
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
      @total.html(NumberFormat.format(issue_value + issue.interest + issue.fee_admin) + " Kč")
      @apr.html(NumberFormat.format(issue.apr, 2) + " %")
      @fee.html(NumberFormat.format(issue.fee_admin) + " Kč")
      @interest.html(NumberFormat.format(issue.interest) + " Kč")
      @rate.html(NumberFormat.format(issue.interest_rate, 2) + " %")
      @instalment_last.html(NumberFormat.format(issue.instalment_last) + " Kč")
      @fees.html(NumberFormat.format(issue.interest + issue.fee_admin) + " Kč")

    tooltip_over: (event) =>
      @current_tooltip = new Tooltip(event)

    tooltip_out: (event) =>
      @current_tooltip.out()


  new Calculator()



