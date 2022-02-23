local Themes = {}

Themes.standard = {
    colors = {
        background = {0.15, 0.15, 0.15, 1.0},
        syntax = {
            text = {1.0, 1.0, 1.0, 1.0},
            identifier = {1.0, 1.0, 1.0, 1.0},
            keywordStruct = {115 / 255, 170 / 255, 213 / 255, 1.0},
            keywordComponent = {115 / 255, 170 / 255, 213 / 255, 1.0},
            keywordFunction = {115 / 255, 170 / 255, 213 / 255, 1.0},
            field = {156 / 255, 196 / 255, 124 / 255, 1.0},
            type = {236 / 255, 92 / 255, 100 / 255, 1.0}
        }
    }
}

Themes.purpor = {
    colors = {
        background = {63 / 255, 40 / 255, 50 / 255, 1.0},
        syntax = {
            text = {1.0, 1.0, 1.0, 1.0},
            identifier = {228 / 255, 166 / 255, 114 / 255, 1.0},
            keywordStruct = {184 / 255, 111 / 255, 80 / 255, 1.0},
            keywordComponent = {184 / 255, 111 / 255, 80 / 255, 1.0},
            keywordFunction = {184 / 255, 111 / 255, 80 / 255, 1.0},
            field = {228 / 255, 166 / 255, 114 / 255, 1.0},
            type = {175 / 255, 191 / 255, 210 / 255, 1.0}
        }
    }
}

Themes.oil = {
    colors = {
        background = {39 / 255, 39 / 255, 68 / 255, 1.0},
        syntax = {
            text = {251 / 255, 245 / 255, 239 / 255, 1.0},
            identifier = {255 / 255, 255 / 255, 255 / 255, 1.0},
            keywordStruct = {104 / 255, 109 / 255, 168 / 255, 1.0},
            keywordComponent = {104 / 255, 109 / 255, 168 / 255, 1.0},
            keywordFunction = {104 / 255, 109 / 255, 168 / 255, 1.0},
            field = {198 / 255, 159 / 255, 165 / 255, 1.0},
            type = {242 / 255, 211 / 255, 171 / 255, 1.0}
        }
    }
}

Themes.current = Themes.oil

return Themes