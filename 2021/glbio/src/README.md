
# Source and working notes for the GLBIO 2021 presentation

# Graphviz notes
```
node[label="" shape="point" width="0.005" height="0.005"]
edge[penwidth=0.1]
```

# Notes 

* sfdp -Tpng tnr_graph.txt > foo.png
* sfdp -Tpng foo.txt -Gdpi=600 > foo.png

## A flower like explosion.
* sfdp -Goverlap=prism data/graph.txt | gvmap  -e | neato -Ecolor="#00000000" -n2 -Tpng > pretty_graph.png


