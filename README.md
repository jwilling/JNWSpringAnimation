## JNWSpringAnimation ##
`JNWSpringAnimation` is a subclass of `CAKeyframeAnimation` that adds support for creating damped harmonic animations.

![](http://appjon.com/assets/github/JNWSpringAnimation.gif)

## Getting Started ##
Although `JNWSpringAnimation` is a subclass of `CAKeyframeAnimation`, it should be treated as if it were a subclass of `CABasicAnimation`. 

To get started, copy the four source files into your project.

The animation can be created by using the dedicated initializer, `+animationWithKeyPath:`. Alternatively, the animation can be created using `+animation` and by setting the key path afterwards. The full list of currently-compatible animatable properties is available in the header.

```objc
JNWSpringAnimation *animation = [JNWSpringAnimation animationWithKeyPath:@"position.x"];
```

Next, the `fromValue` and `toValue` properties must be set for the interpolated values to be calculated correctly.

```objc
animation.toValue = @(toX);
animation.fromValue = @(currentX);
```

Finally, the values for the spring constants can optionally be changed. Currently, `stiffness`, `damping`, and `mass` are available for modification.

```objc
animation.mass = 30; // this will move extremely slowly
// and so on
```

The animation itself can be applied like any other subclass of `CAAnimation`, namely `-addAnimation:forKey:` on any `CALayer`.

## What's this for? ##

This was created in my desire to have an open-source version of the (currently private) `CASpringAnimation` which was discovered in iOS 6.

Spring animations, when used appropriately, can really enhance the way your app feels to the user by connecting in physical simulations with an app's interface. And besides, who doesn't love messing around with springs?

## What's left to do? ##

I created this as a weekend project, so the implementation is still somewhat unfinished. Compared to `CASpringAnimation`, the `velocity` property is still unimplemented. Pull requests are welcome.

## License ##
`JNWSpringAnimation` is licensed under the [MIT](http://opensource.org/licenses/MIT) license. See [LICENSE.md](LICENSE.md).


## Get In Touch ##
You can follow me on Twitter as [@j_willing](http://twitter.com/j_willing), email me at the email listed on my GitHub profile, or read my blog at [jwilling.com](http://www.jwilling.com).
