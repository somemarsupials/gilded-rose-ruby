# Gilded Rose challenge!

This code is based on the initial code located at [this](https://github.com/emilybache/GildedRose-Refactoring-Kata)
repository. The rules of the kata are as follows (from [here](https://github.com/emilybache/GildedRose-Refactoring-Kata/blob/master/GildedRoseRequirements.txt)):

## Gilded Rose Requirements Specification

Hi and welcome to team Gilded Rose. As you know, we are a small inn with a prime location in a
prominent city ran by a friendly innkeeper named Allison. We also buy and sell only the finest goods.
Unfortunately, our goods are constantly degrading in quality as they approach their sell by date. We
have a system in place that updates our inventory for us. It was developed by a no-nonsense type named
Leeroy, who has moved on to new adventures. Your task is to add the new feature to our system so that
we can begin selling a new category of items. First an introduction to our system:

  - All items have a SellIn value which denotes the number of days we have to sell the item
  - All items have a Quality value which denotes how valuable the item is
  - At the end of each day our system lowers both values for every item

Pretty simple, right? Well this is where it gets interesting:

  - Once the sell by date has passed, Quality degrades twice as fast
  - The Quality of an item is never negative
  - "Aged Brie" actually increases in Quality the older it gets
  - The Quality of an item is never more than 50
  - "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
  - "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
  Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
  Quality drops to 0 after the concert

We have recently signed a supplier of conjured items. This requires an update to our system:

  - "Conjured" items degrade in Quality twice as fast as normal items

Feel free to make any changes to the UpdateQuality method and add any new code as long as everything
still works correctly. However, do not alter the Item class or Items property as those belong to the
goblin in the corner who will insta-rage and one-shot you as he doesn't believe in shared code
ownership (you can make the UpdateQuality method and Items property static if you like, we'll cover
for you).

Just for clarification, an item can never have its Quality increase above 50, however "Sulfuras" is a
legendary item and as such its Quality is 80 and it never alters.

## My solution

The rules are quite clear about the fact that we cannot mess around with the Item class, which makes
problem a little bit more challenging to solve. My solution to this issue was the create the concept
of a *typed item*, which is an object that contains an item and a type, along with some parameters to
control how it behaves. This is effectively a wrapper around the item class, allowing us to implement
the behaviour that we need while keeping everyone happy. 

It turns out that the logical behaviour of 
normal items and special items can be modelled on a common set of parameters. This is useful because
we account for most special cases by changing parameters rather than logic. This means that the new
system is much more extensible, following the principle of being *open for extension, not modification*. 

I'll provide a quick run-down of the classes that I've created and what they do.

### DefaultItem

The DefaultItem implements the behaviour of a normal item. It describes the way that an item ages
and changes in value under normal circumstances. The item works on the basis of parameters that
are externally injected, describing things like how quality declines over time. It provides an 
`update` method that is called to ensure that it changes its quality and sell-in date. Internally, 
this calls `update_sell_in` and `update_quality` methods.

### Special items

These are a series of subclasses of the DefaultItem class. In each case, the subclass is either 
initialised with different parameters or has methods added or overridden. In three of the four
cases, we don't have to override the `update_sell_in` and `update_quality` methods because we can
implement the behaviour we need by tweaking parameters or the `quality_change` method.

### TypedItemFactory

This builds typed items from Items. It uses regular expressions to work out what type an item
should be assigned and then generates an array of correspondingly typed items.

### GildedRose

Now, all that GildedRose needs to do is convert Items to typed items as it is initialised. It
then calls `update` on each item once per tick (i.e. per day)!
