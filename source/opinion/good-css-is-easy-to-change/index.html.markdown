---
title: Good CSS is Easy to Change
date: 2015-02-10 09:31 AEDT
tags:
---

This article is about how to assess a piece of CSS. If you can assess CSS well,
you can get better over time at writing it. That will make your colleagues and
your future self happier.

## Good code, bad CSS

On many projects I've worked on, I see a pattern. Even on projects with decent
code, often there is *terrible* CSS. For some reason, all the care and
expertise that went into writing code was forgotten when writing CSS. I imagine
a mature and responsible buttoned down team member piously working away on code
until 4pm opening a CSS file and tipping beer on the keyboard before face
rolling it.

![Code and CSS quality chart](quality-chart.png)

To get you in the right frame of mind, here's a piece of CSS from a previous
project I was contracted on:

```css
ul.data_rows { padding: 0px 0px 0px 20px; }

ul.data_rows li{
  background: rgb(214, 245, 255)
    url(/images/friends_icon.png) 10px center no-repeat;
  overflow: hidden;
  padding: 10px 10px 10px 50px;
  margin: 10px 0 10px 10px;
  border: 2px solid rgb(214, 245, 255);
  -moz-border-radius: 2px;
  -webkit-border-radius: 2px;
  border-radius: 2px;
}
ul.data_rows.w635 { width: 660px !important; }
```

Imagine this is code. Here is a vague approximation in Ruby.

```ruby
def data_rows_list(el)
  el.padding = [0, 0, 0, 20]
  el.each_item do |item|
    item.background ||= [rgb(214, 245, 255),
      '/images/friends_icon.png', 10, :center, :no_repeat]
    item.overflow ||= :hidden
    item.padding ||= [10, 10, 10, 50]
    item.margin ||= [10, 0, 10, 10]
    item.border ||= [2, :solid, rgb(214, 245, 255)]
    item.border-radius ||= 2
    item.width = 660 if el.has_class?('w636')
  end
end
```

As code, this should make you shudder. It has hard coded constants everywhere.
It has duplication. It raises questions:

* What is a *data row* and why is that related to *friend icons*?
* Is `50px` related to the dimensions of the icon?
* If I change the value `660px`, will I have to change that elsewhere too?

Code that raises lots of questions is *bad code*. If you have ever found code
confounding because of questions like these, then you are a rational human being
and you'd be right to call the code poor quality.

If you were tasked with changing this code, there's a high probability that you
would introduce a new bug, because the intention is unclear and because the
interactions are not necessarily logical.

## Where does bad CSS come from?

I have a few theories about why projects end up with good code and poor CSS.

### Internet Explorer cut me

Experienced developers remember a time when they'd wake up in a cold sweat
several times a night because of the agonising hoops they had to jump through
just to get CSS working for a very non-standard browser named IE. Anyone
remember using images to do rounded corners? And potentially, since then,
they've exhausted their care-factor.

![Life is pain](life-is-pain.gif)

### CSS is a configuration file

CSS hasn't always had nice tools to make it easier. Before things like SASS and
LESS, there wasn't actually a way to factor out duplication. That may have
led some programmers to see CSS as a configuration file full of constants
for which applying programming rigour was a lost cause. The fact that it is
declarative and not procedural supports this attitude.

### CSS is graphic design, I don't do that

This seems to apply especially to people with computer science degrees who
studied algorithms and theory and never did a lick of CSS during their degrees.
They program the functionality impressively well and then feel like applying a
coat of paint to their miracle of engineering should be somebody else's job
&mdash; somebody less well paid.

![Not my job](not-my-job.jpg)

Except that many designers provide Photoshop files and see CSS as funny text
code stuff that developers are responsible for. Hence CSS falls into a no-man's
land of responsibility. Everybody on a project throws it over the fence.

### Frustration and low morale

Some people may have been burned by other frustrating experiences with CSS and
have since spent as few minutes as possible in CSS like it's a dirty public
bathroom.

![Arial hates CSS too](arial-frustrated.png)

## Good code is easy to change

Building software is like being in a bouncy castle of changing requirements.
Over the course of a projects, chances are somebody will have to change almost
every line of code you write. For this reason, Corey Haines identifies code as
high quality if it is malleable.

![Corey Haines](corey-haines.jpg)

Corey identifies four properties that make code easy to change:

* **Verifiable**. You can quickly tell that a change you make works.
* **Expresses intent**. You can tell what the code is trying to do.
* **No repetition**. You only edit one bit of code per logical change you
  wish to make.
* **Concise**. You don't have to read a 100 page manual to get started.

CSS is also beholden to crazy jumping castle requirements situation and hence, I
recommend assessing CSS by these guidelines for the same reasons. Let's do that.

## CSS is problematic to verify

The result of CSS is visual and often subjective. There are very few tools
available to help automate the task of assessing the resulting rendering
of CSS. Consequently it is usually the job of a QA human being to sit there
staring at a screen all day and letting you know if something looks "wrong".

There are services that render pages in every browser and device and send
you screenshots of them all and they make life easier but they don't change
the fundamental need for human involvement.

By keeping close track of your sales pipeline statistics and the business
performance of your product, you can assess whether an isolated style update
adversely affected your users or customers.

For the most part though, verifying CSS is relatively slow and expensive
compared to verifying code.

## CSS rarely expresses intent

Does this express intent?

```css
.page { overflow: hidden; }
.page article { float: left; }
.page aside { float: right; }
```

To understand what a piece of CSS intends, it's often necessary to read all the
rules and guess. That's an awful state of affairs. That's like naming all your
methods `method_a`, `method_b`, etc. and asking programmers to read the method
body of each one.

### Comments to convey intent

Plain CSS leaves you with little scope to improve this situation but you could
use comments:

```css
.page { overflow: hidden; /* floated columns container */ }
.page article { float: left; /* big column */ }
.page aside { float: right; /* small column */ }
```

I consider this better because it conveys intent better. But I personally find
CSS comment syntax cumbersome and comments so easily ignored that they grow
out of date. Imagine having to read all the method bodies of functions you
want to use... but now they're commented. Still pretty bad.

### OOCSS to convey intent

OOCSS style class names are another way to convey design intent. They are
akin to the comments above.

```html
<style>
.column-container { overflow: hidden; }
.big-column { float: left; }
.small-column { float: right; }
</style>

<div class="column-container page">
  <article class="big-column">
  </article>
  <aside class="small-column">
  </aside>
</div>
```

The intent here is far clearer than in the base CSS. I consider this vastly
superior to using comments although there are times that comments are
good at supplementing this approach.

### SASS to convey intent

You can use mixins just to convey intent. Keeping the number of lines in your
methods to 3 or fewer is a frequently recommended programming practice. You can
adopt a similar principle with SASS mixins, although perhaps the number is a
bit greater than 3 to account for vendor prefixes and typical atomic design
goals such as setting up the font correctly or setting the colour scheme.

```sass
=column-container
  +clearfix
=big-column
  float: left
=small-column
  float: right

.page
  +column-container
  article
    +big-column
  aside
    +small-column
```

Is this better or worse than the OOCSS solution? The point of this article is
to suggest a way to answer that question. Does this code convey intent better
than the OOCSS solution? I would argue that it does the job equally well in
this regard.

## CSS is repetitive

Here's a subset of the original code. Look at all that repetition!

```css
.data_rows li {
  background-color: rgb(214, 245, 255);
  border: 2px solid rgb(214, 245, 255);
     -moz-border-radius: 2px;
  -webkit-border-radius: 2px;
          border-radius: 2px;
}
```

Preprocessors like SASS and LESS solve this problem very well. OOCSS partially
solves this problem. Plain CSS is riddled with problems like this.

### SASS to fix repetitiveness

Here's an example of using SASS to remove all the repetition in the example above.

```sass
$pale-bg: rgb(214, 245, 255)
$border-width: 2px

.data_rows li
  background-color: $pale-bg
  border: $border-width solid $pale-bg
  +border-radius($border-width)
```

## CSS is rarely concise

How do we achieve conciseness in CSS? Certainly solving repetition reduces
the bulk involved but there are other issues here too.

### Remove unused CSS

Unused CSS is like unused code. It's hard to remove code if you are uncertain
whether it is used and the same is true of CSS. Code coverage measurements and
grepping can help you assess whether a piece of code is used. For CSS, grepping
works too but there are tailor made tools just to hunt down unused CSS so you
can delete it. Browser developer tools sometimes have this option, and there
are web based tools like `unused-css.com` too.

### NoCSS

Unlike code, it is possible to add HTML to your project without the need to add
any new CSS. That happens when the existing CSS that affects the new markup is
already sufficient. Such changes feel very liberating from toiling away in CSS
and consequently very efficient. I call this situation NoCSS, a name inspired
by NoSQL.

NoCSS is the holy grail of CSS. It's almost always beneficial to build HTML and
CSS in such a way that hopefully future additions require no extra CSS.

The name for CSS that potentially applies to every part of your site is called
*baseline* CSS. It is highly reusable, well tested, globally applicable CSS. It
often alleviates cross browser testing demands since the cross-browser testing
is concentrated on the stable reusable baseline CSS. Baseline CSS also helps us
maintain visual design consistency. If you've used Twitter Bootstrap or
similar, you will have felt the convenience of leveraging stable reusable
baseline CSS and how fast it is to make updates to your project that require
no change to CSS.

As you start a project, it's natural to apply CSS directly to each identifiable
component as you go in an ad-hoc manner.

![Worst](Worst.png)

After a while you will notice duplication and feel that factoring out CSS
would be fruitful. The place to factor our CSS is into the baseline.

![Typical](Typical.png)

The most common CSS to put in a baseline are style rules that apply to plain
HTML tags with no id or class.

However you can continue to add to the baseline as long as you treat classes as
HTML tag names that aren't built into HTML. Things like calendars, sliders,
dials, slideshows, etc. are all common in web sites but not baked into HTML.

![Ideal](Ideal.png)

Once you've tried to put the reusable, generalised parts of each component into
a baseline, you will start to get NoCSS updates. For example, you might add a
calendar to a new page and not require any further CSS work.

In such situations, even though the total amount of CSS in your system may
not have changed significantly, the amount of CSS that you are required to
think about and work with as you add and update features in your project has
dropped to zero, which achieves many of the same effects as having extremely
concise CSS.

```css
/* Twitter Bootstrap, Zurb Foundation, custom */

table { /* 10 lines */ }
ul { /* 10 lines */ }
svg { /* 10 lines */ }

/* Reusable and well tested across projects and browsers */

.calendar { /* 50 lines */ }
.list { /* 50 lines */ }
.chart { /* 50 lines */ }

/* -------------------------------------------------------*/

/* Project specific CSS - your new and simpler head space */

.client-calendar { /* 5 lines */ }
.product-list { /* 5 lines */ }
.sales-chart { /* 0 lines */ }
```

## Summary

![Score Card](scorecard.png)

**CSS does suck.** You're right. *Plain* CSS sucks. The style rules
are sometimes poorly named, the browser support can be patchy,
the box model can be inadequete, certain designs can be very
problematic to build, and often the style rules that make something
work don't seem to relate to the nature of the solution. i.e.
a lot of CSS designs are a "hack".

**Tools make CSS suck less.** With practices and tools, CSS
doesn't have to be a ghetto. The benefits of good code can be
felt by the CSS in your project. That is worthwhile.

**Learn the tools and put in some effort.** Especially if you were
burned before and have lost faith, it's a good time to take another look and
see if you can make CSS that's tolerable because a lot has changed in the last
few years.

**Don't be a perfectionist.** Even though CSS related practices
and tools make it much better, it's still an often awkward language
that requires hacks to get the job done. A CSS perfectionist would
be a sad person. Don't be that person!

## Further reading

* [OOCSS](https://github.com/stubbornella/oocss/wiki/faq) - Nicole Sullivan AKA stubbornella on how to write CSS better.
* [SMACSS](http://smacss.com) - Jonathan Snook on the same topic.
* [SASS](http://sass-lang.com) - A CSS preprocessor written in Ruby.
* [LESS](http://lesscss.org/) - Another CSS preprocessor, this time in JavaScript.
* [XP Simplicity](http://c2.com/cgi/wiki?XpSimplicityRules) - Some background on Corey Haines' sentiments.
