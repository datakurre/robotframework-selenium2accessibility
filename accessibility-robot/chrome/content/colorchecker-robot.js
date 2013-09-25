Cu.import("resource://gre/modules/XPCOMUtils.jsm");

var runColorCheck = function(callback) {
    var sidebar, results, errors, i;

    // Force ColorChecker sidebar open
    toggleSidebar("viewcolorchecker_niquelao", true);

    // Get the sidebar document
    sidebar = document.getElementById("sidebar").contentWindow;

    // Wait until the sidebar is loaded
    if (typeof sidebar.bio_niqueladas_colorCheck === "undefined") {
        return window.setTimeout(function() { runColorCheck(callback); }, 100);
    }

    sidebar.document.getElementById("optLevels").selectedIndex = 1;  // 1 = AAA
    sidebar.bio_niqueladas_colorCheck.eliminaSeleccion();
    sidebar.bio_niqueladas_colorCheck.loading(1);
    sidebar.bio_niqueladas_colorCheck.jarl(2);  // 1 == WCAG 1, 2 = WCAG 2

    results = sidebar.document.getElementById("cargador");
    errors = 0;
    for (i = 0; i < results.children.length; i++) {
        if (results.children[i].children[0].getAttribute("properties")
            === "error") {
            errors += 1;
        }
    }
    return callback(errors);
};

var showColorCheckError = function(idx) {
    var sidebar;
    sidebar = document.getElementById("sidebar").contentWindow;
    sidebar.document.getElementById("cargador")
                    .parentNode.view.selection.select(idx);
    sidebar.bio_niqueladas_colorCheck.selectElem(idx);
};

var ColorCheckorRobotObserver = {
    QueryInterface: XPCOMUtils.generateQI([Ci.nsIObserver,
        Ci.nsISupportsWeakReference]),
    observe: function(subject, topic, data) {
        if (topic == "content-document-global-created" &&
            subject instanceof Ci.nsIDOMWindow) {
            XPCNativeWrapper.unwrap(subject)
                            .colorchecker_run=runColorCheck;
            XPCNativeWrapper.unwrap(subject)
                            .colorchecker_show=showColorCheckError;
        }
    }
};

var observerService = Cc["@mozilla.org/observer-service;1"]
    .getService(Ci.nsIObserverService);
observerService.addObserver(ColorCheckorRobotObserver,
    "content-document-global-created", true);
