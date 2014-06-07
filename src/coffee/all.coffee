j11 = jQuery.noConflict true

j11.fn._position = j11.fn.position
j11.fn.position = ( ofobj, vertical ) ->
    self = j11 @
    if arguments.length == 0
        return self._position()
    else
        j11ofobj = j11(ofobj)
    base_offset = j11ofobj.offset()
    base_offset.left += j11ofobj.outerWidth() / 2
    base_offset.left -= self.outerWidth() / 2
    if vertical == 'top'
        base_offset.top += j11ofobj.outerHeight() / 20
    else
        base_offset.top += j11ofobj.outerHeight() / 2
        base_offset.top -= self.outerHeight() / 2
    self.css( base_offset )

j11.fn.hasOneOfClasses = ( classes ) ->
    self = j11 @
    result = false
    switch j11.type(classes)
        when "string"
            self.hasClass classes
        when "array"
            j11.each classes, (i, v) ->
                if self.hasClass(v)
                    result = true
            return result ? false
        else
            false

# control function

bane =
    'metal': 'wood'
    'wood': 'earth'
    'earth': 'water'
    'water': 'fire'
    'fire': 'metal'
translate =
    'metal': '金'
    'wood': '木'
    'earth': '土'
    'water': '水'
    'fire': '火'
cfe = ['metal', 'wood', 'earth', 'water', 'fire']
calcu = j11 '#calcu .modal-content'
select_career = j11 '#select_career .modal-content'
select_attr = j11 '#select_attr .modal-content'
point = j11 '#point .modal-content'
menu = j11 '#menu .modal-content'

opposite = (child) ->
    if j11('#half_left').has(child).length then '#half_right' else '#half_left'

sameside = (child) ->
    if j11('#half_left').has(child).length then '#half_left' else '#half_right'

target = null

show_widget = (wid) -> (e) ->
    self = j11 @
    if self.hasClass('pet-num') && !self.siblings('.pet').children().hasOneOfClasses(cfe)
        self.one('click', show_widget(wid))
        return false
    target = self
    modal = wid.parent()

    self.css('z-index', 9999)
    if wid.is calcu
        wid.removeClass 'for-hp for-sp'
        output.text target.text()
        if self.hasClass 'hp'
            wid.addClass 'for-hp'
        else if self.hasClass 'sp'
            wid.addClass 'for-sp'

    if self.hasClass 'pop-mid'
        wid.removeClass 'for-star for-env for-pet'
        if self.hasClass 'star'
            wid.addClass 'for-star'
        else if self.hasClass 'env'
            target = env
            wid.addClass 'for-env'
        else if self.hasClass 'pet'
            wid.addClass 'for-pet'
        wid.position j11('body'), 'top'
    else if wid.is point
        wid.height(self.outerHeight() + wid.children().outerHeight() * 2)
        wid.position self
    else
        wid.position opposite(self)
    modal.modal('show')
    modal.one 'hidden.bs.modal', ->
        target = null
        self.css('z-index', 0)
        self.one('click', show_widget(wid))

    self.one('click', hide_widget(wid))

hide_widget = (wid) -> (e) ->
    modal = wid.parent()
    modal.modal('hide')

hp = (j11 '.hp').one('click', show_widget(calcu) )
sp = (j11 '.sp').one('click', show_widget(calcu) )
profession = (j11 '.profession').one('click', show_widget(select_career) )
pet = (j11 '.pet').one('click', show_widget(select_attr) )
petnum = (j11 '.pet-num').one('click', show_widget(point) )
dark = (j11 '.dark').one('click', show_widget(point) )
star = (j11 '.star').one('click', show_widget(select_attr) )
env = (j11 '#env').one('click', show_widget(select_attr) )
envtxt = (j11 '#envtxt').one('click', show_widget(select_attr) )
tools = (j11 '#tools').one('click', show_widget(menu) )

change_attr = (obj, attr) ->
    obj.removeClass('metal wood water fire earth').addClass attr

getCookie = (name) ->
    document.cookie.match(name + '=\\w+')?[0].split('=')[1]

initialize = ->
    hp.text (getCookie 'hp_point') ? 250
    sp.text ''
    profession.text '無職業'
    pet.children().attr class: ''
    petnum.text ''
    dark.text ''
    star.children().attr class: ''
    env.children().attr class: ''
    change_attr(envtxt, '').text '無'
    j11('.meteor .spawn').removeClass('spawn').children().fadeTo 'slow', 0.5

spawnstar = (div, attr) ->
    if not div.hasClass attr
        op = j11(opposite(div) + ' .star div')
        opattr = op.attr 'class'
        if bane[attr] is opattr
            op.attr class: ''
        if attr isnt opattr or not attr
            div.attr class: attr
            true
        else
            false
    else
        false

output = j11 '.output', calcu
operator =
    '+': (a, b) -> Number(a) + Number b
    '-': (a, b) -> a - b
    '*': (a, b) -> a * b
    '/': (a, b) -> a // b
    '**': (a, b) -> a ** b
calculate = (s) ->
    m = s.match(/\d+|[\+\*\/-]+/g) ? []
    if m.length is 3
        operator[m[1]] m[0], m[2]
    else if s
        Number s
    else
        ''

(j11 '.num', calcu).click (e) -> output.append j11.trim e.target.textContent
(j11 '.op', calcu).click (e) ->
    result = calculate output.text()
    unless isNaN result
        output.text result + j11.trim e.target.textContent
    else
        output.append j11.trim e.target.textContent
(j11 '.enter', calcu).click (e) ->
    result = calculate output.text()
    output.text result
    target.text(result) unless isNaN result
    calcu.parent().modal('hide')

(j11 '.btn-danger', calcu).click (e) -> output.text target.text()
(j11 '.btn-default', calcu).click (e) -> output.text output.text()[...-1]

j11('.meteor > div').click ->
    self = j11(@)
    if self.hasClass 'spawn'
        self.removeClass('spawn').children().fadeTo 'slow', 0.5
    else
        self.addClass('spawn').children().fadeTo 'slow', 1 if spawnstar j11(sameside(self) + ' .star div'), self.children().attr 'class'

select_attr.find('.btn').click (e) ->
    div = target.children()
    attr = (j11 e.target).attr 'data-attr'
    if target.hasClass 'star'
        spawnstar div, attr
    else
        div.attr class: attr
    if target.hasClass 'pet'
        if attr
            target.next().text 2
        else
            target.next().text ''
    else if target.hasClass 'env'
        change_attr(envtxt, attr).text translate[attr] ? '無'

select_career.find('a').click (e) ->
    e.preventDefault()
    self = j11 e.target
    target.text self.text()

(j11 '#point .add').click ->
    n = Number target.text()
    if not n
        target.text 1
    else if n < 8
        target.text n + 1
(j11 '#point .cut').click ->
    n = Number target.text()
    if 1 < n
        target.text n - 1
    else
        target.text ''
    if not target.text() and target.hasClass 'pet-num'
        target.prev().children().attr class: ''

(j11 '#initi').click initialize
(j11 '#save_setting').click ->
    v = (j11 '#formhp').val()
    document.cookie = 'hp_point=' + v unless isNaN Number v
    (j11 '#setwindow').modal('hide')

# prevent bootstrap modal from steal focus.
(j11 '#setwindow *').bind 'click mouseup mousedown keypress keydown keyup', (e) ->
    e.stopPropagation() if e.which isnt 27 and not (j11 e.target).hasClass 'btn'

# appearance adjustment

tools.popover content: '''Please turn to landscape mode!
請將螢幕橫置瀏覽！'''
detectPortrait = ->
    if innerWidth < innerHeight
        tools.popover 'show'
    else
        tools.popover 'hide'
j11(window).resize detectPortrait
detectPortrait()

# keyboard support
