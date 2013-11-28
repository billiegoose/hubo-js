var c, callback, setColor, highlightLink, progress, select;

c = new WebGLRobots.DefaultCanvas('#hubo_container');
select = document.getElementById('link_list');

hubo = new Hubo('hubo2', callback = function() {
  c.add(hubo);
  $('#panel_load').hide();
  return $(document).ready(function() {
    var linkArray = new Array();
    hubo.links.asArray().forEach(function(link,key,ar) {
      if(link.name != "Body_Head_Empty"){
          linkArray.push(link.name);
        }
    });
    linkArray.sort();
    for(var i = 0; i < linkArray.length; i++){
      var list_option = document.createElement("option");
      list_option.textContent = linkArray[i];
      list_option.value = linkArray[i];
      select.add(list_option);
    }

  });  
}, progress = function(step, total, node) {
  return $('#panel_load').html("Loading " + step + "/" + total);
});

$('#mouse_info_dialog').dialog(
    { autoOpen: false
    , closeOnEscape: true
    , buttons: { OK: function () { $(this).dialog('close'); } }
    }
);

$('#mouse_info_button').on('click', function() { $('#mouse_info_dialog').dialog('open'); });

setColor = function(colorVal) {
  c.autoUpdateObjects = true;
  var x = select.selectedIndex;
  var y = select.options;
 if(x == 0){
    hubo.links.asArray().forEach(function(link,key,ar) {
      var color = new THREE.Color();
      color.setRGB(colorVal[0], colorVal[1], colorVal[2]);
      try {
        link.setColor(color);
      } catch(e) {
        console.log("Hey Will! Fix the Hubo model.");
      }
    });
  }
  else{
    var color = new THREE.Color();
    color.setRGB(colorVal[0], colorVal[1], colorVal[2]);
    hubo.links[y[x].text].setColor(color);
  }
  hubo.canvas.render();
}

highlightLink = function(selectedLink) {
    var x = selectedLink.selectedIndex;
    var y = select.options;
    hubo.links.asArray().forEach(function(link,key,ar) {
      try {
        link.unhighlight();
      } catch(e) {
        console.log(key + " doesn't have an unhighlight. Boo!");
      }
    });
    hubo.links[y[x].text].highlight();
    hubo.canvas.render();
}