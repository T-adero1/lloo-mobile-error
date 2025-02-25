# lloo_mobile

## Modules Overview

Code in this project is broken up into modules and designed to have as little coupling as possible.
Where possible dependencies are uni-directional ("wallet" depends on "user" but not vice versa) 
and always from the bottom up (ie "user" can depend on "core" but "core" does not depend on any other module.)

###### core
Generic or foundational code shared by the modules and which is not belong clearly to a particular module's remit.

###### user
User details including wallet and transaction management. 

###### lloo_read
Search. Displaying of memories.

###### lloo_write
Memory creation.

###### wallet
Reserved for the portion of use it in your face the displays user info and 
data and stats related to user transactions. The actula transaction data and services are considered 
part of "user".



## Code Paradigms

### Naming Conventions

"View" refers to screens or overlay panels that represent main areas of functionality. 
These will generally LlooView (which extends GetX's GetView<>). Behind the scenes they are 
stateless widgets. LlooView automatically has a state and controller attached to it, type
determined from the meta-parameters in the LlooView<> extension. They also have a `theme` 
property that automagically has the correct context.

"ViewController" refers to the controllers that handle view functionality and respond to 
view events. They also bridge Getx observables to Stateful widgets when the Obx() won't do. 
They are named accordingly to differentiate them from controllers for specific widgets which
is core to the Flutter design style.

"Widget" will be reserved for UI components within a view.


### State

Flutter really is more mutable state. This allows granular redrawing of widgets. Though it's possible to
en force immutable state, global redraw, the engine, unlike React, is not really optimised for me and 
most design paradigms (eg Getx) leave you fighting against the stream to maintain the immutable state adherence.

GetX uses .obs to make properties observable. It then looked for this accessors in the widgets to determine what 
needs to be redrawn based on state param changes.

State is both modular and global depending on its need. Modular state needs to be maintined between 
views within a module. This is accomplished by make the state a single using `Get.put(..., permanent: true)`

GetX prefers stateless widgets as it handles the state and re-rendering itself.

### DI Etiquette

DI let's your grab dependencies from anywhere but it's good to have some discipline around this.
Here are some protocols to conform too when possible:

* Generally we prefer to access the state from the LlooView's and LlooControllers (they are automatically available here).
  Pass them into widgets that require them. We might make exceptions here for certian self-contained and cross-module widgets
* Assign all DI gets (i.e. Get.find()) at the top of the class property defs or at the top of function using them.
  With the exception of Widget::build() we prefer to declare DIs as properties on the class. The idea is to make it very obv
  at a glance, what deps the class has.
* Declare module State instances as singleton and permanent via the module init function
  * State should persist at least for app lifetime. Manually reset if needed
* ViewControllers can be singleton and permanent for singleton views (e.g. HomeView). But for views
  that can have multiple instances we need to be more careful (e.g. MemoryDetailsView). Also be sure
  that any singleton VCs handle the fact that their respective views and widget controllers are not permanent and singleton




### Module Organisation

The aim here is from modules to be self-contained and for there to be little to no dependency 
from the top level onto them as possible. In other words you should just be able to delete a module's folder
and it will be removed from the app. In practice there is currently one place where top-level depends on modules.
Modules have initialiser is which is where they declare their roots and bindings.
These are called in main. Initialiser functions from modules allowers to isolate any would-be top-down dependencies 
so so we can limit them to 1 line in the main function.


* Use the _template folder for quick start for new section (and keep it up to date)

A little about the folders...

##### Controllers

There are two times with and rollers: ViewController and standard (Widget) Controllers. 
Name them accordingly so that we can distinguish them easily. ViewControllers for one to one
with the Views.  They generally extend `LlooViewController`.

You might be tempted to have one controller per module but IMO it's better to follow the Getx routing 
paradigm of one controller per view.


#### Bindings

Getx constructs/disposes bindings per screen so we can have separate bindings for each 
view but in practice it is useful to make them lazy invocations.  You do have to use 
`permanent: true` for state so that it persists for the lifetime of the module — lifetime 
of the app really – but this is a good thing. Remembering the last view state is good UX.
It can manually be reset if desired.



### Name Conventions

* In a module, name the main controller and main view with the name of the module (e.g. Cue2LitController & Cue2LitView)
* Widgets: If the name alone clearly indicates that is a UI element then use the name alone is the class name (e.g. LlooLogo) 
  But if it is unclear and then append "Widget" To the class (e.g ProgressWidget)

### App & Component Styling


## Error Handling

* For programmatic / developer logic errors, rely on system exceptions. For ones born of semi-expected user
experience or volatile data and state (e.g. disk read) then use custom app-DSL exception. 


###