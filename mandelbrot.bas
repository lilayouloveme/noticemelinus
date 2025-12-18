_Title "Sophisticated Animated Mandelbrot in QB64"

Const sw = 320
Const sh = 200

myScreen = _NewImage(sw, sh, 32)
SCREEN myScreen
_Dest myScreen

maxiter = 30
centerR = -0.75 ' Interesting point to zoom into
centerI = 0.1
zoom = 0.5 ' Initial zoom

Do
    minr = centerR - 1.5 / zoom
    maxr = centerR + 1.5 / zoom
    mini = centerI - 1.0 / zoom
    maxi = centerI + 1.0 / zoom

    For py = 0 To sh - 1
        ci = mini + (maxi - mini) * py / (sh - 1)
        For px = 0 To sw - 1
            cr = minr + (maxr - minr) * px / (sw - 1)
            zr = 0: zi = 0
            zrsqr = 0: zisqr = 0
            iter = 0
            Do While iter < maxiter And zrsqr + zisqr < 4
                temp = zrsqr - zisqr + cr
                zi = 2 * zr * zi + ci
                zr = temp
                zrsqr = zr * zr
                zisqr = zi * zi
                iter = iter + 1
            Loop
            If iter = maxiter Then
                PSet (px, py), _RGB32(0, 0, 0)
            Else
                ' Smooth coloring
                mu = iter + 1 - Log(Log(Sqr(zrsqr + zisqr))) / Log(2)
                hue = mu / 100 * 360 ' Adjust for color spread
                sat = 1
                brightness = 1 - (mu Mod 1) * 0.5
                c = hsv_to_rgb(hue, sat, brightness)
                PSet (px, py), c
            End If
        Next px
    Next py

    _Display
    zoom = zoom * 1.02 ' Gentle zoom
    _Limit 5 ' Slow for visibility

Loop Until InKey$ <> ""

System

Function hsv_to_rgb (h, s, v)
    c = v * s
    x = c * (1 - Abs(((h / 60) Mod 2) - 1))
    m = v - c
    If h < 60 Then
        r = c: g = x: b = 0
    ElseIf h < 120 Then
        r = x: g = c: b = 0
    ElseIf h < 180 Then
        r = 0: g = c: b = x
    ElseIf h < 240 Then
        r = 0: g = x: b = c
    ElseIf h < 300 Then
        r = x: g = 0: b = c
    Else
        r = c: g = 0: b = x
    End If
    r = (r + m) * 255
    g = (g + m) * 255
    b = (b + m) * 255
    hsv_to_rgb = _RGB32(r, g, b)
End Function

