# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $(document).mousemove (event) ->
    dx = $("body").data("x")
    if dx is `undefined`
      $("body").data "vx", true
      $("body").data "vy", true
      $("body").data "vz", true
    else
      dy = event.pageY - $("body").data("y")
      dx = event.pageX - $("body").data("x")
      dz = dy * dx
      dz/= Math.abs(dz)
      vx = $("body").data("vx")
      vy = $("body").data("vy")
      vz = $("body").data("vz")
      rgb = $("body").css("background-color").replace(/(rgb\(\s*)(\d+\s*,\s*\d+\s*,\s*\d+)(\s*\))/g, "$2").split(",")
      if rgb.length is 3
        r = parseInt(rgb[0])
        g = parseInt(rgb[1])
        b = parseInt(rgb[2])
        if (vx and ((dx > 0 and r is 255) or (dx < 0 and r is 0))) or (not vx and ((dx < 0 and r is 255) or (dx > 0 and r is 0)))
          vx = not vx
          $("body").data "vx", vx
        if (vy and ((dy > 0 and g is 255) or (dy < 0 and g is 0))) or (not vy and ((dy < 0 and g is 255) or (dy > 0 and g is 0)))
          vy = not vy
          $("body").data "vy", vy
        if (vz and ((dz > 0 and b is 255) or (dz < 0 and b is 0))) or (not vz and ((dz < 0 and b is 255) or (dz > 0 and b is 0)))
          vz = not vz
          $("body").data "vz", vz
        b += ((if dz > 0 then 1 else -1)) * ((if vz then 1 else -1))  unless dz is 0
        b = b.toString(16)
        b = "0" + b  while b.length < 2
        g += ((if dy > 0 then 1 else -1)) * ((if vy then 1 else -1))  unless dy is 0
        g = g.toString(16)
        g = "0" + g  while g.length < 2
        r += ((if dx > 0 then 1 else -1)) * ((if vx then 1 else -1))  unless dx is 0
        r = r.toString(16)
        r = "0" + r  while r.length < 2
        $("body").css "background-color", "#" + r + g + b
      else   $("body").css "background-color", "#ffff7f"
    $("body").data "x", event.pageX
    $("body").data "y", event.pageY
