<%@ tag description="Page layout" %>

<%@ attribute name="title"       required="true" description="Page title" %>
<%@ attribute name="keywords"    required="true" description="Page keywords to improve SEO" %>
<%@ attribute name="description" required="true" description="Page description" %>
<%@ attribute name="extraHeader" fragment="true" description="Extra code to put before head" %>
<%@ attribute name="extraBottom" fragment="true" description="Extra code to put before body" %>
<%@ attribute name="species" fragment="false" description="Species" %>
<%@ attribute name="image" fragment="false" description="Image" %>
<%@ attribute name="eg_keywords" fragment="false" description="e.g. keywords" %>
<%@ attribute name="chromosomes" fragment="false" description="Chromosomes" %>
<%@ attribute name="bgcolor" fragment="false" description="Background color" %>
<%@ attribute name="assembly" fragment="false" description="Genome assembly" %>
<%@ attribute name="species_name" fragment="false" description="species_name" %>

<%@ taglib tagdir="/WEB-INF/tags/layout" prefix="layout" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
        <meta name="keywords" content="${keywords}" />
        <meta name="description" content="${description}" />
        <title>${title}</title>
        <!-- favicon added -->
        <link rel="shortcut icon" href="html/image/favicon.ico" >

        <link rel="stylesheet" type="text/css" href="html/css/style.css"/> <!-- common style.css -->
        <!-- GeneMap -->
        <link rel="stylesheet" type="text/css" href="html/GeneMap/dist/styles/genemap-lib.css"/>
        <link rel="stylesheet" type="text/css" href="html/GeneMap/dist/styles/genemap.css"/>
        <!-- KnetMaps -->
        <link href="html/KnetMaps/css/knet-style.css" rel="stylesheet" /> <!-- KnetMaps stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/qtip2/2.2.0/jquery.qtip.min.css" rel="stylesheet" type="text/css" />
        <link href="html/KnetMaps/css/maskloader.css" rel="stylesheet">

        <link href="https://fonts.googleapis.com/css?family=Kanit|Play" rel="stylesheet">

        <!-- GeneMap -->
        <script type="text/javascript" src="html/GeneMap/dist/js/genemap-lib.js"></script>
        <script type="text/javascript" src="html/GeneMap/dist/js/genemap.js"></script>

        <!-- KnetMaps -->
    <!--    <script src="html/KnetMaps/libs/jquery-1.11.2.min.js"></script> --> <!-- already loaded by GeneMap -->
        <script src="html/KnetMaps/libs/cytoscapejs_2.4.0/cytoscape.min.js"></script>
        <script src="html/KnetMaps/libs/jquery-ui.js"></script>
        <script src="html/KnetMaps/libs/cytoscape-cxtmenu.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/qtip2/2.2.0/jquery.qtip.min.js"></script>
        <script src="html/KnetMaps/libs/cytoscape-qtip.js"></script>
        <script src="html/KnetMaps/libs/jquery.maskloader.js"></script>
        <!-- Layouts -->
        <script src="html/KnetMaps/libs/cose_bilkent/cytoscape-cose-bilkent.js"></script>
        <script src="html/KnetMaps/libs/ngraph_forceLayout/cytoscape-ngraph.forcelayout.js"></script>
        <!-- URL mappings config file used for generating url's in Item Info table -->
        <script type="text/javascript" src="html/KnetMaps/config/url_mappings.json"></script>
        <!-- KnetMaps code -->
        <script src="html/KnetMaps/javascript/knet-maskLoader.js"></script>
        <script src="html/KnetMaps/javascript/knet-layouts-defaultParams.js"></script>
        <script src="html/KnetMaps/javascript/knet-layouts.js"></script>
        <script src="html/KnetMaps/javascript/knet-menu.js"></script> <!-- KnetMaps menubar -->
        <script src="html/KnetMaps/javascript/knet-stats.js"></script> <!-- Network stats -->
        <script src="html/KnetMaps/javascript/knet-container.js"></script>
        <script src="html/KnetMaps/javascript/knet-toggleFullScreen.js"></script>
        <script src="html/KnetMaps/javascript/knet-conceptsLegend.js"></script> <!-- dynamic, interactive ConceptsLegend -->
        <script src="html/KnetMaps/javascript/knet-itemInfo.js"></script>
        <script src="html/KnetMaps/javascript/knet-generator.js"></script>
        
        <script type="text/javascript" src="html/javascript/utils-config.js"></script>
        <script type="text/javascript" src="html/GeneView/summariseLegend.js"></script> <!-- interactive summary Legend for Gene View -->
        <script type="text/javascript" src="html/javascript/utils.js"></script>
      	<script type="text/javascript" src="html/javascript/jquery.tablesorter.js"></script>
		
	<script src="https://use.fontawesome.com/a90751c39e.js"></script>
	
        <jsp:invoke fragment="extraHeader"/>
        
        <!-- Google Analytics -->
        <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
                
            ga('create', 'UA-88753233-1', 'auto');
            ga('send', 'pageview');
        </script>
        <!-- end Google Analytics -->
    </head>
    <body>
        <!-- Main -->
        <div id="wrapper">
        	<layout:header species="${species}" />
 			<layout:content eg_keywords="${eg_keywords}" chromosomes="${chromosomes}"  assembly="${assembly}"/>
            <layout:footer/>
        </div>
        <jsp:invoke fragment="extraBottom"/>
    </body>
</html>
