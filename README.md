<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->

<a name="readme-top"></a>

<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h2 align="center">Toy DNS resolver</h2>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

This is the result of following [Julia Evans'](https://jvns.ca/) [Wizard Zines](https://wizardzines.com/) guide called [Implement DNS in a weekend](https://implement-dns.wizardzines.com/).

One of Julias' difficulty-increasing optional recommendations was to reimplement the original Python code in a different language of our choosing.

I chose to do it in Lua! 🌙

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

- [![Lua][Lua-badge]][Lua-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

### Prerequisites

- [Lua](https://www.lua.org/download.html)
- [LuaRocks](https://github.com/luarocks/luarocks/wiki/Download) - for installing dependencies

### Installation

1. Clone the repo

   ```sh
   git clone https://github.com/wem1c/weekend_dns_lua.git
   ```

2. Open the project folder in your terminal

   ```sh
   cd weekend_dns_lua
   ```

3. Install dependencies

   ```sh
   luarocks install luasocket
   ```

4. Run the entry file using lua

   ```sh
   lua weekend_dns.lua
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

The source code is freely distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

Conor C. Peterson - [@wemic@social.linux.pizza](https://social.linux.pizza/@wemic) - conorpetersondev@gmail.com

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

- [Implement DNS in a weekend](https://implement-dns.wizardzines.com/) by [Julia Evans](https://jvns.ca/) for [Wizard Zines](https://wizardzines.com/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/wem1c/weekend_dns_lua.svg?style=for-the-badge
[contributors-url]: https://github.com/wem1c/weekend_dns_lua/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/wem1c/weekend_dns_lua.svg?style=for-the-badge
[forks-url]: https://github.com/wem1c/weekend_dns_lua/network/members
[stars-shield]: https://img.shields.io/github/stars/wem1c/weekend_dns_lua.svg?style=for-the-badge
[stars-url]: https://github.com/wem1c/weekend_dns_lua/stargazers
[issues-shield]: https://img.shields.io/github/issues/wem1c/weekend_dns_lua.svg?style=for-the-badge
[issues-url]: https://github.com/wem1c/weekend_dns_lua/issues
[Lua-badge]: https://img.shields.io/badge/lua-000080?style=for-the-badge&logo=lua
[Lua-url]: https://www.lua.org/
