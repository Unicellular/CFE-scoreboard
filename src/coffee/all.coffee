j11 = jQuery.noConflict true
j11.blockUI.defaults.css = cursor: 'auto'

# control function

hp_point = [250, 250]
sp_point = [0, 0, 0, 0]
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
calcu = j11 '.calcu'
select_career = j11 '#select_career'
select_attr = j11 '#select_attr'
point = j11 '#point'
menu = j11 '#menu'

initialize = ->

opposite = (child) ->
    if j11('#half_left').has(child).length then '#half_right' else '#half_left'

sameside = (child) ->
    if j11('#half_left').has(child).length then '#half_left' else '#half_right'

target = null

pop_widget = (wid) -> (e) ->
    # TODO: set widget position
    target = self = j11 @
    self.css('z-index', 1011)
    wid.css('opacity', 0)
    j11.blockUI
        message: wid
        onOverlayClick: ->
            j11.unblockUI()
            target = null
            self.css('z-index', 0)
        onBlock: ->
            if wid.hasClass 'calcu'
                wid.removeClass('for-hp').removeClass 'for-sp'
                if self.hasClass 'hp'
                    wid.addClass 'for-hp'
                else if self.hasClass 'sp'
                    wid.addClass 'for-sp'

            if self.hasClass 'pop-mid'
                wid.removeClass('for-star').removeClass('for-env').removeClass 'for-pet'
                if self.hasClass 'star'
                    wid.addClass 'for-star'
                else if self.hasClass 'env'
                    target = env
                    wid.addClass 'for-env'
                else if self.hasClass 'pet'
                    wid.addClass 'for-pet'
                wid.parent().position
                    my: 'top'
                    at: 'top+5%'
                    of: j11 '.blockOverlay'
            else if wid.is point
                wid.height(self.outerHeight() + wid.children().outerHeight() * 2)
                wid.parent().position
                    of: self
            else
                wid.parent().position
                    of: opposite(self)
            wid.css('opacity', 1)

hp = (j11 '.hp').click pop_widget calcu
sp = (j11 '.sp').click pop_widget calcu
profession = (j11 '.profession').click pop_widget select_career
pet = (j11 '.pet').click pop_widget select_attr
petnum = (j11 '.pet-num').click pop_widget point
dark = (j11 '.dark').click pop_widget point
star = (j11 '.star').click pop_widget select_attr
env = (j11 '#env').click pop_widget select_attr
envtxt = (j11 '#envtxt').click pop_widget select_attr
tools = (j11 '#tools').click pop_widget menu

spawnstar = (div, attr) ->
    if not div.hasClass attr
        op = j11(opposite(div) + ' .star div')
        opattr = op.attr 'class'
        if bane[attr] == opattr
            op.attr class: ''
        if attr isnt opattr
            div.attr 'class', attr
            true
        else
            false
    else
        false

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
        spawnstar div
    else
        div.attr 'class', attr
    if target.hasClass 'pet'
        if attr
            target.next().text 2
        else
            target.next().text ''
    else if target.hasClass 'env'
        envtxt.attr class: attr
        envtxt.text translate[attr] ? '無'

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
        target.prev().children().attr 'class', ''

# appearance adjustment

tools.popover content: '''Please turn to landscape mode!
請將螢幕橫置瀏覽！'''
detectPortrait = ->
    if innerWidth < innerHeight
        tools.popover('show')
    else
        tools.popover('hide')
j11(window).resize detectPortrait
detectPortrait()

# keyboard support
