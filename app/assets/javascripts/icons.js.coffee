# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $(document).mousemove((event) ->
    dx = $("body").data("x")
    if dx is `undefined`
      $("body").data "vx", true
      $("body").data "vy", true
    else
      dy = event.pageY - $("body").data("y")
      dx = event.pageX - $("body").data("x")
      vx = $("body").data("vx")
      vy = $("body").data("vy")
      rgb = $("body").css("background-color").replace(/(rgb\(\s*)(\d+\s*,\s*\d+\s*,\s*\d+)(\s*\))/g, "$2").split(",")
      if rgb.length is 3
        if (vx and ((dx > 0 and rgb[0] is 255) or (dx < 0 and rgb[0] is 0))) or (not vx and ((dx < 0 and rgb[0] is 255) or (dx > 0 and rgb[0] is 0)))
          vx = not vx
          $("body").data "vx", vx
        if (vy and ((dy > 0 and rgb[1] is 255) or (dy < 0 and rgb[1] is 0))) or (not vy and ((dy < 0 and rgb[1] is 255) or (dy > 0 and rgb[1] is 0)))
          vy = not vy
          $("body").data "vy", vy
        b = parseInt(rgb[2]).toString(16)
        b = "0" + b  while b.length < 2
        rgb[1] = parseInt(rgb[1])
        rgb[1] += ((if dy > 0 then 1 else -1)) * ((if vy then 1 else -1))  unless dy is 0
        g = rgb[1].toString(16)
        g = "0" + g  while g.length < 2
        rgb[0] = parseInt(rgb[0])
        rgb[0] += ((if dx > 0 then 1 else -1)) * ((if vx then 1 else -1))  unless dx is 0
        r = rgb[0].toString(16)
        r = "0" + r  while r.length < 2
        $("body").css "background-color", "#" + r + g + b
      else   $("body").css "background-color", "#ffff7f"
    $("body").data "x", event.pageX
    $("body").data "y", event.pageY
  ).click (event) ->
    rgb = $("body").css("background-color").replace(/(rgb\(\s*)(\d+\s*,\s*\d+\s*,\s*\d+)(\s*\))/g, "$2").split(",")
    if rgb.length is 3
      r = parseInt(rgb[0]).toString(16)
      g = parseInt(rgb[1]).toString(16)
      b = parseInt(rgb[2])
      if event.which is 1 and b < 255
        b += 5
      else b -= 5  if event.which is 2 and b > 0
      b = b.toString(16)
      b = "0" + b  while b.length < 2
      $("body").css "background-color", "#" + r + g + b
    else   $("body").css "background-color", "#ffff7f"
