<%-- 
    Document   : correlationMatrix
    Created on : Jan 8, 2016, 6:07:05 PM
    Author     : aurea
--%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Correlation matrix with linked scatterplot</title>
	<link rel=stylesheet type="text/css" href="corr_w_scatter.css">
	<!--<script type="text/javascript" src="d3.js"></script>-->
	<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
	<script src="d3.extend.js" charset="utf-8"></script>
</head>
<body>
	<div id="plot">
		<!--div id="corrTooltip" class="tooltip">
			<p><em>r</em> = <span class="value">0</span></p>
		</div-->
		<div id="scatTooltip" class="tooltip">
			<p>ID: <span class="value">value</span></p>
		</div>
		<div id="instrucs"></div>
		<!--label id="showLineLabel"><input type="checkbox" id="showLine" />Show regression line</label-->
	</div>
	<button id="shuffleCorr">Shuffle variable order</button>
	<button id="shuffleDefault">Restore default</button>
	<script type="text/javascript" src="options.js"></script>
	<script type="text/javascript" src="corr_w_scatter.js"></script>
</body>
</html>