local B = {}

function B.init( client )
   client.state.outbuf[1] = [[

  _____                              _
 |  __ \                            (_)
 | |  | | __ ___   _____ _ __   __ _ _ _ __   ___
 | |  | |/ _` \ \ / / _ \ '_ \ / _` | | '_ \ / _ \
 | |__| | (_| |\ V /  __/ | | | (_| | | | | |  __/
 |_____/ \__,_| \_/ \___|_| |_|\__, |_|_| |_|\___|
                                __/ |
                               |___/

                "Remember that you will die."
What is your name? ]]
   return true -- so as not to fuck up the assert
end

return B
