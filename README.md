# AMHudView

![Example HUDs](examples.png)

I've been using [MBProgressHUD](https://github.com/jdg/MBProgressHUD) for a few years but finally hit the point where the API was getting in my way. So I started this project.

The main benefits of using AMHudView are:

* Only supports the latest iOS version (currently iOS 7). No crufty code for old versions.
* Always take advantage of newest language/SDK features.
* Cancelable
* Determinate (UIProgressView) or Indeterminate (UIActivtyIndicatorView)
* Uses Autolayout
* No delegate, just blocks
* Super simple to use

## Basic Usage

	AMHudView *hud = [[AMHudView alloc]init];
	hud.mainLabelText = @"Hello, World!";
	[hud showOverView:self.view];
	//and later when done with task
	[hud hide];

Lots of variations are shown in `AMViewController.h`. To use with your project, just add `AMHudView.[h,m]`.

## License

AMHudView is released under the MIT license.

> Copyright (c) 2013 Agile Monks, LLC.

> Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

>The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
