var GENEMAP = GENEMAP || {};


GENEMAP.GeneAnnotations = function (userConfig) {
  var defaultConfig = {
    border: false,
    labelRectangles: false,
    onAnnotationSelectFunction: $.noop(),
    longestChromosome: 100,
    layout: {
      width: 10,
      height: 100,
      x: 0,
      y: 0,
    },
    chromosomeWidth: 20,
    annotationMarkerSize: 5,
    annotationLabelSize: 5,
    showAnnotationLabels: true,
    infoBoxManager: GENEMAP.InfoBox(),
    nClusters: 6,
    doClustering: 6,
  };

  var config = _.merge({}, defaultConfig, userConfig);

  var buildYScale = function () {
    return d3.scale.linear().range([0, config.layout.height]).domain([0, config.longestChromosome]);
  };

  // adds the gene annotations to the annotations group within it, uses the data
  // bound to the annotationsGroup to generate the annotation elements
  var setupGeneAnnotations = function (annotationGroup, chromosome) {

    var y = buildYScale();

    //We can build nodes directly from genes or from gene clusters
    //NB a gene cluster might be a single gene anyway
    var nodeSource = chromosome.annotations.genes;
    if ( config.doClustering) {
      nodeSource = chromosome.annotations.gene_clusters;
    }

    var nodes = nodeSource.map(function (d) {
      return new labella.Node(y(d.midpoint), config.annotationMarkerSize, d);
    } );

    var force = new labella.Force({
      nodeSpacing: 3,
      algorithm: 'overlap',
      lineSpacing: 2,
      minPos: 0,
      maxPos: config.layout.height,
    }).nodes(nodes).compute();

    var renderer = new labella.Renderer({
      direction: 'right',
      layerGap: config.layout.width / 3.0,
      nodeHeight: config.annotationMarkerSize * 1.5 + config.annotationLabelSize * 5.0  ,
    });

    renderer.layout(force.nodes());

    // Enter + Update elements
    var geneAnnotations = annotationGroup.selectAll('g.gene-annotation').data(force.nodes());

    var geneAnnotationsEnterGroup = geneAnnotations.enter().append('g').classed('gene-annotation', true);

    geneAnnotationsEnterGroup.append('line').classed('midpoint-line', true);
    geneAnnotationsEnterGroup.append('path').classed('link', true);

    if (config.labelRectangles) {
      geneAnnotationsEnterGroup.append('rect').classed('labella', true);
    }

    geneAnnotationsEnterGroup.append('polygon').classed('infobox', true);
    geneAnnotationsEnterGroup.append('text');

    geneAnnotations.attr('id', function (d) {
      return 'feature_' + d.data.id;
    });

    geneAnnotations.select('line.midpoint-line').attr({
      x1: -(config.chromosomeWidth * 0.5),
      y1: function (d) { return y(d.data.midpoint); },
      y2: function (d) { return y(d.data.midpoint); },
      x2: 0,
    });

    config.infoBoxManager.setupInfoboxOnSelection(geneAnnotations);

    geneAnnotations.on('click', function (d) {
      if (d.data.type == "gene") {
        console.log('gene annotation click ');
        var group = d3.select(this);
        group.classed('selected', !group.classed('selected'));
        config.onAnnotationSelectFunction();
        return false;
      }
    });

    // generate  markers
    var pointsFn = function (d) {
      var points = [];

      var a = config.annotationMarkerSize;
      //genes represented by triangles
      if (d.data.type == "gene") {

        var h = Math.sqrt(Math.pow(a, 2) - Math.pow((a / 2), 2));
        h = h * 1.5; // stretch the width of the triangle

        points.push([d.x, d.y]);
        points.push([d.x + h, d.y - a / 2]);
        points.push([d.x + h, d.y + a / 2]);

      }
      //gene clusters represented by squares
      else if (d.data.type == "geneslist") {
        points.push([d.x , d.y + a / 2]);
        points.push([d.x , d.y - a / 2]);
        points.push([d.x + a , d.y - a / 2]);
        points.push([d.x + a , d.y + a / 2]);
      }

      return points.join(' ');
    };

    geneAnnotations.select('polygon').attr({
      points: pointsFn,
    }).style({
      fill: function (d) {
        return d.data.color;
      },
    });

    geneAnnotations.select('path.link')
      .attr({
        d: function (d) { return renderer.generatePath(d); },
      });

    // draw the labella labels as rectangles, useful for debugging
    if (config.labelRectangles) {
      geneAnnotations.select('rect.labella').attr({
          fill: 'green',
          stroke: 'none',
          x: function (d) { return d.x; },
          y: function (d) {
            return d.y - d.dy / 2;
          },
          width: function (d) { return d.dx; },
          height: function (d) { return d.dy; },
        });
    }

    geneAnnotations.select('text').attr({
      x: function (d) { return d.x + config.annotationMarkerSize + config.annotationLabelSize; },
      y: function (d) { return d.y + (0.4 * config.annotationLabelSize); },
    }).style({
      'font-size': config.annotationLabelSize + 'px',
      visibility: function (d) {
        if (d.data.showLabel === 'show') {
          return 'visible';
        } else if (d.data.showLabel === 'hide') {
          return 'hidden';
        }

        return config.showAnnotationLabels ? 'visible' : 'hidden';
      },
    }).text(function (d) {
      if (d.data.type == "gene") {
        return d.data.label;
      }
      else if (d.data.type == "geneslist"){
        return "(" + d.data.genes_list.length + ")";
      }
    });

    geneAnnotations.exit().remove();
  };

  // draw a border around the annotation target element
  var drawBorder = function (group) {

    // create the border element if it doesn't exist
    if (group.select('rect.border').empty()) {
      group.append('rect').classed('border', true);
    }

    group.select('rect.border')
      .attr({
        width: config.layout.width,
        height: config.layout.height,
      });
  };

  // An SVG representation of a chromosome with banding data. This won't create an SVG
  // element, it expects that to already have been created.
  function my(selection) {
    selection.each(function (d) {

      var annotationGroup = d3.select(this).selectAll('.gene-annotations').data([d]);

      annotationGroup.enter().append('g').attr('class', 'gene-annotations');

      annotationGroup.attr({
        transform: 'translate(' + config.layout.x + ',' + config.layout.y + ')',
        id: function (d) { return 'annotation_' + d.number; },
      });

      setupGeneAnnotations(annotationGroup, d);

      if (config.border) {
        drawBorder(annotationGroup);
      }

      annotationGroup.exit().remove();
    });
  }

  my.onAnnotationSelectFunction = function (value) {
    if (!arguments.length) {
      return config.onAnnotationSelectFunction;
    }

    config.onAnnotationSelectFunction = value;
    return my;
  };

  my.layout = function (value) {
    if (!arguments.length) {
      return config.layout;
    }

    config.layout = value;
    return my;
  };

  my.longestChromosome = function (value) {
    if (!arguments.length) {
      return config.longestChromosome;
    }

    config.longestChromosome = value;
    return my;
  };

  my.chromosomeWidth = function (value) {
    if (!arguments.length) {
      return config.chromosomeWidth;
    }

    config.chromosomeWidth = value;
    return my;
  };

  my.annotationLabelSize = function (value) {
    if (!arguments.length) {
      return config.annotationLabelSize;
    }

    config.annotationLabelSize = value;
    return my;
  };

  my.annotationMarkerSize = function (value) {
    if (!arguments.length) {
      return config.annotationMarkerSize;
    }

    config.annotationMarkerSize = value;
    return my;
  };

  my.showAnnotationLabels = function (value) {
    if (!arguments.length) {
      return config.showAnnotationLabels;
    }

    config.showAnnotationLabels = value;
    return my;
  };

  my.infoBoxManager = function (value) {
    if (!arguments.length) {
      return config.infoBoxManager;
    }

    config.infoBoxManager = value;
    return my;
  };

  my.nClusters = function(value) {
    if (!arguments.length) {
      return config.nClusters;
    }

    config.nClusters = value;
    return my;
  }

  my.doClustering = function(value) {
    if (!arguments.length) {
      return config.doClustering;
    }

    config.doClustering = value;
    return my;
  }

  return my;
};
