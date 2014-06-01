// Generated by CoffeeScript 1.7.1
(function() {
  var bane, calcu, dark, detectPortrait, env, envtxt, hp, hp_point, initialize, j11, menu, opposite, pet, petnum, point, pop_widget, profession, sameside, select_attr, select_career, sp, sp_point, spawnstar, star, target, tools, translate;

  j11 = jQuery.noConflict(true);

  j11.fn._position = j11.fn.position;

  j11.fn.position = function(ofobj, vertical) {
    var base_offset, j11ofobj, self;
    self = j11(this);
    if (arguments.length === 0) {
      return self._position();
    } else {
      j11ofobj = j11(ofobj);
    }
    base_offset = j11ofobj.offset();
    base_offset.left += j11ofobj.outerWidth() / 2;
    base_offset.left -= self.outerWidth() / 2;
    if (vertical === 'top') {
      base_offset.top += j11ofobj.outerHeight() / 20;
    } else {
      base_offset.top += j11ofobj.outerHeight() / 2;
      base_offset.top -= self.outerHeight() / 2;
    }
    return self.css(base_offset);
  };

  hp_point = [250, 250];

  sp_point = [0, 0, 0, 0];

  bane = {
    'metal': 'wood',
    'wood': 'earth',
    'earth': 'water',
    'water': 'fire',
    'fire': 'metal'
  };

  translate = {
    'metal': '金',
    'wood': '木',
    'earth': '土',
    'water': '水',
    'fire': '火'
  };

  calcu = j11('#calcu .modal-content');

  select_career = j11('#select_career .modal-content');

  select_attr = j11('#select_attr .modal-content');

  point = j11('#point .modal-content');

  menu = j11('#menu .modal-content');

  initialize = function() {};

  opposite = function(child) {
    if (j11('#half_left').has(child).length) {
      return '#half_right';
    } else {
      return '#half_left';
    }
  };

  sameside = function(child) {
    if (j11('#half_left').has(child).length) {
      return '#half_left';
    } else {
      return '#half_right';
    }
  };

  target = null;

  pop_widget = function(wid) {
    return function(e) {
      var modal, self;
      target = self = j11(this);
      modal = wid.parent();
      self.css('z-index', 9999);
      modal.one('show.bs.modal', function() {
        if (wid.is(calcu)) {
          wid.removeClass('for-hp').removeClass('for-sp');
          if (self.hasClass('hp')) {
            wid.addClass('for-hp');
          } else if (self.hasClass('sp')) {
            wid.addClass('for-sp');
          }
        }
        if (self.hasClass('pop-mid')) {
          wid.removeClass('for-star').removeClass('for-env').removeClass('for-pet');
          if (self.hasClass('star')) {
            wid.addClass('for-star');
          } else if (self.hasClass('env')) {
            target = env;
            wid.addClass('for-env');
          } else if (self.hasClass('pet')) {
            wid.addClass('for-pet');
          }
          return wid.position(j11('body'), 'top');
        } else if (wid.is(point)) {
          wid.height(self.outerHeight() + wid.children().outerHeight() * 2);
          return wid.position(self);
        } else {
          return wid.position(opposite(self));
        }
      });
      modal.one('hide.bs.modal', function() {
        target = null;
        return self.css('z-index', 0);
      });
      return modal.modal('toggle');
    };
  };

  hp = (j11('.hp')).click(pop_widget(calcu));

  sp = (j11('.sp')).click(pop_widget(calcu));

  profession = (j11('.profession')).click(pop_widget(select_career));

  pet = (j11('.pet')).click(pop_widget(select_attr));

  petnum = (j11('.pet-num')).click(pop_widget(point));

  dark = (j11('.dark')).click(pop_widget(point));

  star = (j11('.star')).click(pop_widget(select_attr));

  env = (j11('#env')).click(pop_widget(select_attr));

  envtxt = (j11('#envtxt')).click(pop_widget(select_attr));

  tools = (j11('#tools')).click(pop_widget(menu));

  spawnstar = function(div, attr) {
    var op, opattr;
    if (!div.hasClass(attr)) {
      op = j11(opposite(div) + ' .star div');
      opattr = op.attr('class');
      if (bane[attr] === opattr) {
        op.attr({
          "class": ''
        });
      }
      if (attr !== opattr) {
        div.attr('class', attr);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  };

  j11('.meteor > div').click(function() {
    var self;
    self = j11(this);
    if (self.hasClass('spawn')) {
      return self.removeClass('spawn').children().fadeTo('slow', 0.5);
    } else {
      if (spawnstar(j11(sameside(self) + ' .star div'), self.children().attr('class'))) {
        return self.addClass('spawn').children().fadeTo('slow', 1);
      }
    }
  });

  select_attr.find('.btn').click(function(e) {
    var attr, div, _ref;
    div = target.children();
    attr = (j11(e.target)).attr('data-attr');
    if (target.hasClass('star')) {
      spawnstar(div);
    } else {
      div.attr('class', attr);
    }
    if (target.hasClass('pet')) {
      if (attr) {
        return target.next().text(2);
      } else {
        return target.next().text('');
      }
    } else if (target.hasClass('env')) {
      envtxt.attr({
        "class": attr
      });
      return envtxt.text((_ref = translate[attr]) != null ? _ref : '無');
    }
  });

  select_career.find('a').click(function(e) {
    var self;
    e.preventDefault();
    self = j11(e.target);
    return target.text(self.text());
  });

  (j11('#point .add')).click(function() {
    var n;
    n = Number(target.text());
    if (!n) {
      return target.text(1);
    } else if (n < 8) {
      return target.text(n + 1);
    }
  });

  (j11('#point .cut')).click(function() {
    var n;
    n = Number(target.text());
    if (1 < n) {
      target.text(n - 1);
    } else {
      target.text('');
    }
    if (!target.text() && target.hasClass('pet-num')) {
      return target.prev().children().attr('class', '');
    }
  });

  tools.popover({
    content: 'Please turn to landscape mode!\n請將螢幕橫置瀏覽！'
  });

  detectPortrait = function() {
    if (innerWidth < innerHeight) {
      return tools.popover('show');
    } else {
      return tools.popover('hide');
    }
  };

  j11(window).resize(detectPortrait);

  detectPortrait();

}).call(this);
