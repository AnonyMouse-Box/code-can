// ==UserScript==
// @name         Torn Bazaar Filler
// @namespace    https://github.com/SOLiNARY
// @version      0.8.5
// @description  On "Fill" click autofills bazaar item price with lowest bazaar price currently minus $1 (can be customised), shows current price coefficient compared to 3rd lowest, fills max quantity for items, marks checkboxes for guns.
// @author       Ramin Quluzade, Silmaril [2665762]
// @license      MIT License
// @match        https://www.torn.com/bazaar.php*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=torn.com
// @require      https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js
// @run-at       document-idle
// @grant        GM_addStyle
// @grant        GM_registerMenuCommand 
// ==/UserScript==
// This is a modified version of the script to allow more accessible functionality of the price management.
// Modifications written and tested by V1rul3nt_Sm0g [2861188] and the modified script can be found here https://github.com/AnonyMouse-Box/code-can/blob/main/javascript/tornscripts/bazaar-filler.js

(function() {
    'use strict';

    const bazaarUrl = "https://api.torn.com/market/{itemId}?selections=bazaar,itemmarket&key={apiKey}";
    const failsafeUrl = "https://api.torn.com/torn/{itemId}?selections=items&key={apiKey}";
    let priceDeltaRaw = localStorage.getItem("silmaril-torn-bazaar-filler-price-delta") ?? '-1';
    let bazaarListingRaw = localStorage.getItem("silmaril-torn-bazaar-filler-listing-choice") ?? '3';
    let failsafeRaw = localStorage.getItem("silmaril-torn-bazaar-filler-failsafe") ?? true;
    let useItemMarket = localStorage.getItem("silmaril-torn-bazaar-filler-itemmarket") ?? true;
    let apiKey = localStorage.getItem("silmaril-torn-bazaar-filler-apikey");

    try {
        GM_registerMenuCommand('Set Price Delta', setPriceDelta);
        GM_registerMenuCommand('Set Bazaar Listing', setBazaarListing);
        GM_registerMenuCommand('Set Item Market', setItemMarket);
        GM_registerMenuCommand('Set Failsafe', setFailsafe);
        GM_registerMenuCommand('Set Api Key', function() { checkApiKey(false); });
    } catch (error) {
        console.log('[TornBazaarFiller] Tampermonkey not detected!');
    }

    // TornPDA support for GM_addStyle
    let GM_addStyle = function (s) {
        let style = document.createElement("style");
        style.type = "text/css";
        style.innerHTML = s;
        document.head.appendChild(style);
    };

    GM_addStyle(`
.btn-wrap.torn-bazaar-fill-qty-price {
	float: right;
    margin-left: auto;
    z-index: 99999;
}

.btn-wrap.torn-bazaar-clear-qty-price {
    z-index: 99999;
}

div.title-wrap div.name-wrap {
	display: flex;
    justify-content: flex-end;
}

.wave-animation {
  position: relative;
  overflow: hidden;
}

.wave {
  pointer-events: none;
  position: absolute;
  width: 100%;
  height: 33px;
  background-color: transparent;
  opacity: 0;
  transform: translateX(-100%);
  animation: waveAnimation 1s cubic-bezier(0, 0, 0, 1);
}

@keyframes waveAnimation {
  0% {
    opacity: 1;
    transform: translateX(-100%);
  }
  100% {
    opacity: 0;
    transform: translateX(100%);
  }
}

.overlay-percentage {
    position: absolute;
    top: 0px;
    background-color: rgba(0, 0, 0, 0.9);
    padding: 0px 5px;
    border-radius: 15px;
    font-size: 10px;
}

.overlay-percentage-add {
    right: -30px;
}

.overlay-percentage-manage {
    right: 0px;
}
`);

    const pages = { "AddItems": 10, "ManageItems": 20};
    const addItemsLabels = ["Fill", "Clear"];
    const updateItemsLabels = ["Update", "Clear"];

    const viewPortWidthPx = window.innerWidth;
    const isMobileView = viewPortWidthPx <= 784;

    const observerTarget = $(".content-wrapper")[0];
    const observerConfig = { attributes: false, childList: true, characterData: false, subtree: true };

    const observer = new MutationObserver(function(mutations) {
        let mutation = mutations[0].target;
        if (mutation.classList.contains("items-cont") || mutation.classList.contains("core-layout___uf3LW")) {
            $("ul.ui-tabs-nav").on("click", "li:not(.ui-state-active):not(.ui-state-disabled):not(.m-show)", function() {
                observer.observe(observerTarget, observerConfig);
            });
            $("div.topSection___U7sVi").on("click", "div.linksContainer___LiOTN a[aria-labelledby=add-items]", function(){
                observer.observe(observerTarget, observerConfig);
            });
            $("div.topSection___U7sVi").on("click", "div.listItem___Q3FFU a[aria-labelledby=add-items]", function(){
                observer.observe(observerTarget, observerConfig);
            });
            $("div.topSection___U7sVi").on("click", "div.linksContainer___LiOTN a[aria-labelledby=manage-items]", function(){
                observer.observe(observerTarget, observerConfig);
            });
            $("div.topSection___U7sVi").on("click", "div.listItem___Q3FFU a[aria-labelledby=manage-items]", function(){
                observer.observe(observerTarget, observerConfig);
            });

            let containerItems = $("ul.items-cont li.clearfix");
            containerItems.find("div.title-wrap div.name-wrap").each(function(){
                let isParentRowDisabled = this.parentElement.parentElement.classList.contains("disabled");
                let alreadyHasFillBtn = this.querySelector(".btn-wrap.torn-bazaar-fill-qty-price") != null;
                if (!alreadyHasFillBtn && !isParentRowDisabled){
                    insertFillAndWaveBtn(this, addItemsLabels, pages.AddItems);
                }
            });

            let containerItemsManage = $("div.row___n2Uxh");
            containerItemsManage.find("div.item___jLJcf div.desc___VJSNQ").each(function(){
                let alreadyHasUpdateBtn = this.querySelector(".btn-wrap.torn-bazaar-fill-qty-price") != null;
                if (!alreadyHasUpdateBtn) {
                    insertFillAndWaveBtn(this, updateItemsLabels, pages.ManageItems);
                }
            });
        }
    });
    observer.observe(observerTarget, observerConfig);

    function insertFillAndWaveBtn(element, buttonLabels, pageType){
        const waveDiv = document.createElement('div');
        waveDiv.className = 'wave';

        const outerSpanFill = document.createElement('span');
        outerSpanFill.className = 'btn-wrap torn-bazaar-fill-qty-price';
        const outerSpanClear = document.createElement('span');
        outerSpanClear.className = 'btn-wrap torn-bazaar-clear-qty-price';

        const innerSpanFill = document.createElement('span');
        innerSpanFill.className = 'btn';
        const innerSpanClear = document.createElement('span');
        innerSpanClear.className = 'btn';
        innerSpanClear.style.display = 'none';

        const inputElementFill = document.createElement('input');
        inputElementFill.type = 'button';
        inputElementFill.value = buttonLabels[0];
        inputElementFill.className = 'torn-btn';
        const inputElementClear = document.createElement('input');
        inputElementClear.type = 'button';
        inputElementClear.value = buttonLabels[1];
        inputElementClear.className = 'torn-btn';

        innerSpanFill.appendChild(inputElementFill);
        innerSpanClear.appendChild(inputElementClear);
        outerSpanFill.appendChild(innerSpanFill);
        outerSpanClear.appendChild(innerSpanClear);

        element.append(outerSpanFill, outerSpanClear, waveDiv);

        switch(pageType) {
            case pages.AddItems:
                $(outerSpanFill).on("click", "input", function(event) {
                    checkApiKey();
                    this.parentNode.style.display = "none";
                    fillQuantityAndPrice(this, pageType);
                    event.stopPropagation();
                });

                $(outerSpanClear).on("click", "input", function(event) {
                    this.parentNode.style.display = "none";
                    clearQuantityAndPrice(this);
                    event.stopPropagation();
                });
                break;
            case pages.ManageItems:
                $(outerSpanFill).on("click", "input", function(event) {
                    checkApiKey();
                    // this.parentNode.style.display = "none";
                    updatePrice(this);
                    event.stopPropagation();
                });

                // $(outerSpanClear).on("click", "input", function(event) {
                //     this.parentNode.style.display = "none";
                //     clearQuantity(this, pageType);
                //     event.stopPropagation();
                // });
                break;
        }

    }

    function insertPercentageSpan(element){
        let moneyGroupDiv = element.querySelector("div.price div.input-money-group");

        if (moneyGroupDiv.querySelector("span.overlay-percentage") === null) {
            const percentageSpan = document.createElement('span');
            percentageSpan.className = 'overlay-percentage overlay-percentage-add';
            moneyGroupDiv.appendChild(percentageSpan);
        }

        return moneyGroupDiv.querySelector("span.overlay-percentage");
    }

    function insertPercentageManageSpan(element){
        let moneyGroupDiv = element.querySelector("div.input-money-group");

        if (moneyGroupDiv.querySelector("span.overlay-percentage") === null) {
            const percentageSpan = document.createElement('span');
            percentageSpan.className = 'overlay-percentage overlay-percentage-manage';
            moneyGroupDiv.appendChild(percentageSpan);
        }

        return moneyGroupDiv.querySelector("span.overlay-percentage");
    }

    function fillQuantityAndPrice(element, pageType){
        let amountDiv = element.parentElement.parentElement.parentElement.parentElement.parentElement.querySelector("div.amount-main-wrap");
        let priceInputs = amountDiv.querySelectorAll("div.price div input");
        let keyupEvent = new Event("keyup", {bubbles: true});
        let inputEvent = new Event("input", {bubbles: true});

        let image = element.parentElement.parentElement.parentElement.parentElement.querySelector("div.image-wrap img");
        let numberPattern = /\/(\d+)\//;
        let match = image.src.match(numberPattern);
        let extractedItemId = 0;
        if (match) {
            extractedItemId = parseInt(match[1], 10);
        } else {
            console.error("[TornBazaarFiller] ItemId not found!");
        }

        let requestUrl = bazaarUrl
        .replace("{itemId}", extractedItemId)
        .replace("{apiKey}", apiKey);

        let wave = element.parentElement.parentElement.parentElement.querySelector("div.wave");
        fetch(requestUrl)
            .then(getResponse => getResponse.json())
            .then(getData => {
            if (getData.error != null && getData.error.code === 2){
                apiKey = null;
                localStorage.setItem("silmaril-torn-bazaar-filler-apikey", null);
                wave.style.backgroundColor = "red";
                wave.style.animationDuration = "5s";
                console.error("[TornBazaarFiller] Incorrect Api Key:", getData);
                return;
            }
            let failsafeRequestUrl = failsafeUrl
            .replace("{itemId}", extractedItemId)
            .replace("{apiKey}", apiKey);

            fetch(failsafeRequestUrl)
                .then(failsafeResponse => failsafeResponse.json())
                .then(failsafeData => {
                if (failsafeData.error != null && failsafeData.error.code === 2){
                    apiKey = null;
                    localStorage.setItem("silmaril-torn-bazaar-filler-apikey", null);
                    wave.style.backgroundColor = "red";
                    wave.style.animationDuration = "5s";
                    console.error("[TornBazaarFiller] Incorrect Api Key:", failsafeData);
                    return;
                }
                let failsafe = failsafeRaw ? failsafeData.items[extractedItemId.toString()].market_value : 0;
                let itemMarket = useItemMarket ? getData.itemmarket[0].cost : 0;
                let lowBallPrice = Math.round(performOperation(Math.max(getData.bazaar[Math.min(bazaarListingRaw - 1, getData.bazaar.length - 1)].cost, itemMarket, failsafe), priceDeltaRaw));
                let price3rd = getData.bazaar[Math.min(2, getData.bazaar.length - 1)].cost;
                let priceCoefficient = ((lowBallPrice / price3rd) * 100).toFixed(0);

                let percentageOverlaySpan = insertPercentageSpan(amountDiv);
                if (priceCoefficient <= 95){
                    percentageOverlaySpan.style.display = "block";
                    if (priceCoefficient <= 50){
                        percentageOverlaySpan.style.color = "red";
                        wave.style.backgroundColor = "red";
                        wave.style.animationDuration = "5s";
                    } else if (priceCoefficient <= 75){
                        percentageOverlaySpan.style.color = "yellow";
                        wave.style.backgroundColor = "yellow";
                        wave.style.animationDuration = "3s";
                    } else {
                        percentageOverlaySpan.style.color = "green";
                        wave.style.backgroundColor = "green";
                    }
                    percentageOverlaySpan.innerText = priceCoefficient + "%";
                } else {
                    percentageOverlaySpan.style.display = "none";
                    wave.style.backgroundColor = "green";
                }

                priceInputs[0].value = lowBallPrice;
                priceInputs[1].value = lowBallPrice;
                priceInputs[0].dispatchEvent(inputEvent);
            })
        })
            .catch(error => {
            wave.style.backgroundColor = "red";
            wave.style.animationDuration = "5s";
            console.error("[TornBazaarFiller] Error fetching data:", error);
        })
            .finally(() => {
            element.parentNode.parentNode.parentNode.querySelector("span.btn-wrap.torn-bazaar-clear-qty-price span.btn").style.display = "inline-block";
        });
        wave.style.animation = 'none';
        wave.offsetHeight;
        wave.style.animation = null;
        wave.style.backgroundColor = "transparent";
        wave.style.animationDuration = "1s";

        let isQuantityCheckbox = amountDiv.querySelector("div.amount.choice-container") !== null;
        if (isQuantityCheckbox){
            amountDiv.querySelector("div.amount.choice-container input").click();
        } else {
            let quantityInput = amountDiv.querySelector("div.amount input");
            quantityInput.value = getQuantity(element, pageType);
            quantityInput.dispatchEvent(keyupEvent);
        }
    }

    function updatePrice(element){
        let moneyGroupDiv;
        let parentNode4 = element.parentNode.parentNode.parentNode.parentNode;
        if (isMobileView){
            if (parentNode4.querySelector(".menuActivators___STzEc button.iconContainer___H3dWv[aria-label=Manage] span.active___OTFsm") == null) {
                parentNode4.querySelector(".menuActivators___STzEc button.iconContainer___H3dWv[aria-label=Manage]").click();
            }
            moneyGroupDiv = parentNode4.parentNode.querySelector(".bottomMobileMenu___CCSjc .priceMobile___cpt8p");
        } else {
            moneyGroupDiv = element.parentNode.parentNode.parentNode.parentNode.querySelector("div.price___DoKP7");
        }
        let priceInputs = moneyGroupDiv.querySelectorAll("div.input-money-group input");
        let inputEvent = new Event("input", {bubbles: true});

        let image = element.parentElement.parentElement.parentElement.parentElement.querySelector("div.imgContainer___tEZeE img");
        let extractedItemId = getItemIdFromImage(image);

        let requestUrl = bazaarUrl
        .replace("{itemId}", extractedItemId)
        .replace("{apiKey}", apiKey);

        let wave = element.parentElement.parentElement.parentElement.querySelector("div.wave");
        fetch(requestUrl)
            .then(getResponse => getResponse.json())
            .then(getData => {
            if (getData.error != null && getData.error.code === 2){
                apiKey = null;
                localStorage.setItem("silmaril-torn-bazaar-filler-apikey", null);
                wave.style.backgroundColor = "red";
                wave.style.animationDuration = "5s";
                console.error("[TornBazaarFiller] Incorrect Api Key:", getData);
                return;
            }
            let failsafeRequestUrl = failsafeUrl
            .replace("{itemId}", extractedItemId)
            .replace("{apiKey}", apiKey);

            fetch(failsafeRequestUrl)
                .then(failsafeResponse => failsafeResponse.json())
                .then(failsafeData => {
                if (failsafeData.error != null && failsafeData.error.code === 2){
                    apiKey = null;
                    localStorage.setItem("silmaril-torn-bazaar-filler-apikey", null);
                    wave.style.backgroundColor = "red";
                    wave.style.animationDuration = "5s";
                    console.error("[TornBazaarFiller] Incorrect Api Key:", failsafeData);
                    return;
                }
                let failsafe = failsafeRaw ? failsafeData.items[extractedItemId.toString()].market_value : 0;
                let itemMarket = useItemMarket ? getData.itemmarket[0].cost : 0;
                let lowBallPrice = Math.round(performOperation(Math.max(getData.bazaar[Math.min(bazaarListingRaw - 1, getData.bazaar.length - 1)].cost, itemMarket, failsafe), priceDeltaRaw));
                let price3rd = getData.bazaar[Math.min(2, getData.bazaar.length - 1)].cost;
                let priceCoefficient = ((lowBallPrice / price3rd) * 100).toFixed(0);

                let percentageOverlaySpan = insertPercentageManageSpan(moneyGroupDiv);
                if (priceCoefficient <= 95){
                    percentageOverlaySpan.style.display = "block";
                    if (priceCoefficient <= 50){
                        percentageOverlaySpan.style.color = "red";
                        wave.style.backgroundColor = "red";
                        wave.style.animationDuration = "5s";
                    } else if (priceCoefficient <= 75){
                        percentageOverlaySpan.style.color = "yellow";
                        wave.style.backgroundColor = "yellow";
                        wave.style.animationDuration = "3s";
                    } else {
                        percentageOverlaySpan.style.color = "green";
                        wave.style.backgroundColor = "green";
                    }
                    percentageOverlaySpan.innerText = priceCoefficient + "%";
                } else {
                    percentageOverlaySpan.style.display = "none";
                    wave.style.backgroundColor = "green";
                }

                priceInputs[0].value = lowBallPrice;
                priceInputs[1].value = lowBallPrice;
                priceInputs[0].dispatchEvent(inputEvent);
            })
        })
            .catch(error => {
            wave.style.backgroundColor = "red";
            wave.style.animationDuration = "5s";
            console.error("[TornBazaarFiller] Error fetching data:", error);
        })
            .finally(() => {
            // element.parentNode.parentNode.parentNode.querySelector("span.btn-wrap.torn-bazaar-clear-qty-price span.btn").style.display = "inline-block";
        });
        wave.style.animation = 'none';
        wave.offsetHeight;
        wave.style.animation = null;
        wave.style.backgroundColor = "transparent";
        wave.style.animationDuration = "1s";
    }

    function clearQuantityAndPrice(element){
        let amountDiv = element.parentElement.parentElement.parentElement.parentElement.parentElement.querySelector("div.amount-main-wrap");
        let priceInputs = amountDiv.querySelectorAll("div.price div input");
        let keyupEvent = new Event("keyup", {bubbles: true});
        let inputEvent = new Event("input", {bubbles: true});

        let wave = element.parentElement.parentElement.parentElement.querySelector("div.wave");
        wave.style.backgroundColor = "white";

        let isQuantityCheckbox = amountDiv.querySelector("div.amount.choice-container") !== null;
        if (isQuantityCheckbox){
            amountDiv.querySelector("div.amount.choice-container input").click();
        } else {
            let quantityInput = amountDiv.querySelector("div.amount input");
            quantityInput.value = "";
            quantityInput.dispatchEvent(keyupEvent);
        }

        priceInputs[0].value = "";
        priceInputs[1].value = "";
        priceInputs[0].dispatchEvent(inputEvent);

        wave.style.animation = 'none';
        wave.offsetHeight;
        wave.style.animation = null;

        element.parentNode.parentNode.parentNode.querySelector("span.btn-wrap.torn-bazaar-fill-qty-price span.btn").style.display = "inline-block";
    }

    //     function clearQuantity(element, pageType){
    //         let itemRow = element.parentNode.parentNode.parentNode.parentNode;
    //         let moneyGroupDiv = itemRow.querySelector("div.price___DoKP7");
    //         let keyupEvent = new Event("keyup", {bubbles: true});

    //         let wave = element.parentElement.parentElement.parentElement.querySelector("div.wave");
    //         wave.style.backgroundColor = "white";

    //         let quantityInput = itemRow.querySelector("div.remove___R4eVW input");
    //         quantityInput.value = getQuantity(element, pageType);
    //         quantityInput.dispatchEvent(keyupEvent);

    //         wave.style.animation = 'none';
    //         wave.offsetHeight;
    //         wave.style.animation = null;

    //         element.parentNode.parentNode.parentNode.querySelector("span.btn-wrap.torn-bazaar-fill-qty-price span.btn").style.display = "inline-block";
    //     }

    function getQuantity(element, pageType){
        let rgx = /x(\d+)$/;
        let rgxMobile = /^x(\d+)/
        let quantityText = 0;
        switch(pageType){
            case pages.AddItems:
                quantityText = element.parentNode.parentNode.parentNode.innerText;
                break;
            case pages.ManageItems:
                quantityText = element.parentNode.parentNode.parentNode.querySelector("span").innerText;
                break;
        }
        let match = isMobileView ? rgxMobile.exec(quantityText) : rgx.exec(quantityText);
        let quantity = match === null ? 1 : match[1];
        return quantity;
    }

    function getItemIdFromImage(image){
        let numberPattern = /\/(\d+)\//;
        let match = image.src.match(numberPattern);
        if (match) {
            return parseInt(match[1], 10);
        } else {
            console.error("[TornBazaarFiller] ItemId not found!");
        }
    }

    function performOperation(number, operation) {
        // Parse the operation string to extract the operator and value
        const match = operation.match(/^([-+]?)(\d+(?:\.\d+)?)(%)?$/);

        if (!match) {
            throw new Error('Invalid operation string');
        }

        const [, operator, operand, isPercentage] = match;
        const operandValue = parseFloat(operand);

        // Check for percentage and convert if necessary
        const adjustedOperand = isPercentage ? (number * operandValue) / 100 : operandValue;

        // Perform the operation based on the operator
        switch (operator) {
            case '':
            case '+':
                return number + adjustedOperand;
            case '-':
                return number - adjustedOperand;
            default:
                throw new Error('Invalid operator');
        }
    }

    function setPriceDelta() {
        let userInput = prompt('Enter price delta formula (default: -1):', priceDeltaRaw);
        if (userInput !== null) {
            priceDeltaRaw = userInput;
            localStorage.setItem("silmaril-torn-bazaar-filler-price-delta", userInput);
        } else {
            console.error("[TornBazaarFiller] User cancelled the Price Delta input.");
        }
    }

    function setBazaarListing() {
        let loop = true;
        while (loop === true) {
            let userInput = prompt('Enter which bazaar listing (1-3) to use:', bazaarListingRaw);
            if (userInput !== null) {
                let listingValue = userInput.parseInt();
                if (listingValue.isNaN() !== true && listingValue > 0 && listingValue < 4) {
                    bazaarListingRaw = listingValue;
                    loop = false;
                } else {
                    alert("Please enter a listing between 1 and 3");
                }
            } else {
                console.error("[TornBazaarFiller] User cancelled the Bazaar Listing input.");
            }
        }
        localStorage.setItem("silmaril-torn-bazaar-filler-listing-choice", bazaarListingRaw);
    }

    function setFailsafe() {
        let loop = true;
        while (loop === true) {
            let userInput = prompt('Turn the value failsafe on or off (true or false):', failsafeRaw);
            if (userInput !== null) {
                switch (userInput.toLowerCase()) {
                    case "true":
                        failsafeRaw = true;
                        loop = false;
                        break;
                    case "false":
                        failsafeRaw = false;
                        loop = false;
                        break;
                    default: alert("Please enter a boolean value");
                }
            } else {
                console.error("[TornBazaarFiller] User cancelled the failsafe setting input.");
                loop = false;
            }
        }
        localStorage.setItem("silmaril-torn-bazaar-filler-failsafe", failsafeRaw);
    }

    function setItemMarket() {
        let loop = true;
        while (loop === true) {
            let userInput = prompt('Turn the use of item market values on or off (true or false):', useItemMarket);
            if (userInput !==null) {
                switch (userInput.toLowerCase()) {
                    case "true":
                        useItemMarket = true;
                        loop = false;
                        break;
                    case "false":
                        useItemMarket = false;
                        loop = false;
                        break;
                    default: alert("Please enter a boolean value");
                }
            } else {
                console.error("[TornBazaarFiller] User cancelled the item market setting input.");
                loop = false;
            }
        }
        localStorage.setItem("silmaril-torn-bazaar-filler-itemmarket", useItemMarket);
    }

    function checkApiKey(checkExisting = true) {
        if (!checkExisting || apiKey === null || apiKey.length != 16){
            let userInput = prompt("Please enter a PUBLIC Api Key, it will be used to get current bazaar prices:", apiKey ?? '');
            if (userInput !== null && userInput.length == 16) {
                apiKey = userInput;
                localStorage.setItem("silmaril-torn-bazaar-filler-apikey", userInput);
            } else {
                console.error("[TornBazaarFiller] User cancelled the Api Key input.");
            }
        }
    }
})();
