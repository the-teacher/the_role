<h2 align="center" class='center' style="text-align:center">
  TheRole 3.0
</h2>

<p align="center" class='center' style="text-align:center">
  <b>Authorization gem for Ruby on Rails</b>
  <i>with <a href="https://github.com/TheRole/TheRoleManagementPanelBootstrap3">Management Panel</a></i>
</p>

<p align="center" class='center' style="text-align:center">
  <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/the_role.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</p>

<p align="center" class='center' style="text-align:center">
  <b>Semantic. Flexible. Lightweight</b>
</p>

<div align="center" class='center' style="text-align:center">
TheRole: <a href="http://badge.fury.io/rb/the_role"><img src="https://badge.fury.io/rb/the_role.svg" alt="Gem Version" height="18"></a>
API: <a href="http://badge.fury.io/rb/the_role_api"><img src="https://badge.fury.io/rb/the_role_api.svg" alt="Gem Version" height="18"></a>
GUI: <a href="http://badge.fury.io/rb/the_role_management_panel"><img src="https://badge.fury.io/rb/the_role_management_panel.svg" alt="Gem Version" height="18"></a>
CI: <a href="https://travis-ci.org/TheRole/DummyApp"><img src="https://travis-ci.org/TheRole/DummyApp.svg?branch=master" alt="Build Status" height="18"></a>
&nbsp;<a href="https://www.ruby-toolbox.com/categories/rails_authorization">ruby-toolbox</a>
</div>

<hr>
<p align="center" class='center' style="text-align:center">
  Strongly recommended <a href='https://github.com/TheRole/docs/blob/master/MigrationsFromV2.md'>to upgrade from TheRole2 to TheRole3</a>. Please, do it ASAP.
</p>
<hr>

### INTRO

TheRole is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access. All permissions are defined in with **2-level-hash**, and **stored in the database as a JSON string**.

<p align="center" class='center' style="text-align:center">
  <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/hash2string.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</p>

Using hashes, makes role system extremely easy to configure and use

* Any Role is a two-level hash, consisting of the <b>sections</b> and nested <b>rules</b>
* A <b>Section</b> may be associated with a <b>controller</b> name
* A <b>Rule</b> may be associated with an <b>action</b> name
* A Section can have many rules
* A Rule can be <b>true</b> or <b>false</b>
* <b>Sections</b> and nested <b>Rules</b> provide an <b>ACL</b> (<b>Access Control List</b>)

#### Management Panel

<table>
<tr>
  <td>
    <b>http://localhost:3000/admin/roles</b>
  </td>
</tr>
<tr>
  <td>
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/gui.png?2" alt="TheRole GUI">
  </td>
</tr>
</table>

**Import/Export operations provided via TheRole Management Panel.** If you have 2 Rails apps, based on TheRole - you can move roles between them via export/import abilities of TheRole Management Panel.
It can be usefull for Rails apps based on one engine.

<div align="center" class='center' style="text-align:center">
  <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/import_export.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</div>

#### Limitations by Design

TheRole uses few conventions over configuration.
It gives simplicity of code, but also some limitations.
You have to know about them before using of TheRole:
<a href="https://github.com/TheRole/docs/blob/master/Limitations.md">Limitations list</a>

<hr>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/TheRoleInstallation.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/install.png?2" alt="TheRole. Installation">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/TheRoleAPI.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/api.png" alt="TheRole API">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/IntegrationWithRailsControllers.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/int_ctrl.png" alt="Integration with Rails controllers">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/IntegrationWithRailsViews.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/int_views.png" alt="Integration with Rails views">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/UsingWithStrongParameters.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/int_params.png" alt="Using with Strong Parameters">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/docs/blob/master/TheRoleGuiInstallation.md">
    <img src="https://raw.githubusercontent.com/TheRole/docs/master/images/install_gui.png" alt="TheRole GUI. Installation">
  </a>
</div>

<hr>

### FAQ

<div align="center" class='center' style="text-align:center">

<table>
<tr>
  <td>
    <table>
        <tr>
          <td width="350px" valign="top" style='vertical-align:top'>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/FAQ.md#why-therole-was-created'>Why TheRole was created?</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/FAQ.md#who-is-administrator'>Who is Administrator?</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/FAQ.md#who-is-moderator'>Who is Moderator?</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/FAQ.md#who-is-owner'>Who is Owner?</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/Ownership.md'>Few words about Ownership</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/Customization.md'>Customization, Rake tasks, code generators</a></p>
          </td>
       </tr>
     </table>
  </td>

  <td>
    <table>
        <tr>
          <td width="350px" valign="top" style='vertical-align:top'>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/FAQ.md##what-does-it-mean-semantic'>What does it mean semantic?</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/FAQ.md#virtual-sections-and-rules'>Virtual sections and rules</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/Limitations.md'>Limitations</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/Contributing.md'>Contributing</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/MigrationsFromV2.md'>Migration form TheRole 2 to TheRole 3</a></p>
            <p align="left" class="left" style="text-align:left"><a href='https://github.com/TheRole/docs/blob/master/forPostgresSQLusers.md'>PSQL: how to use native :json column?</a></p>
          </td>
        </tr>
    </table>  
  </td>
</tr>
</table>

</div>

<hr>

### We need your feedback!

If you have to say something about TheRole, or if you need help, there are few ways to contact us:

0. SKYPE:    **ilya.killich**
0. Email:    zykin-ilya@ya.ru
0. TWITTER:  [@iam_teacher](https://twitter.com/iam_teacher)
0. Hash tag: [#the_role](https://twitter.com/hashtag/the_role)
0. Google group: [about the_role](https://groups.google.com/forum/#!forum/the_role)

<hr>

#### Test matrix

* **RAILS:** 3.2.21, 4.0, 4.1, 4.2
* **RUBY:** 1.9.3, 2.0, 2.1, 2.2
* **DB**: sqlite, mysql, postgresql

totally: 48 environments

<hr>

**Supported locales:**
[the_role_api](https://github.com/TheRole/the_role_api/tree/master/config/locales) |
[the_role_management_panel](https://github.com/TheRole/the_role_management_panel/tree/master/config/locales)
(please, help us with them)
<hr>

### MIT License

[MIT License](https://github.com/TheRole/docs/blob/master/LICENSE.md)
Copyright (c) 2012-2015 [Ilya N.Zykin](https://github.com/the-teacher)

#### Maintainers

[@the-teacher](https://github.com/the-teacher),
[@sedx](https://github.com/sedx),
[@seuros](https://github.com/seuros)

#### Contributors

[@igmarin](https://github.com/igmarin)
[@doabit](https://github.com/doabit)
[@linjunpop](https://github.com/linjunpop)
[@egb3](https://github.com/egb3)
[@klacointe](https://github.com/klacointe)
[@niltonvasques](https://github.com/niltonvasques)

[Thanks for contributors](https://github.com/the-teacher/the_role/graphs/contributors)
