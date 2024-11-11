//-----------------------------------------------------------------------------------
//
// Distributed under MIT Licence
//   See https://github.com/house-of-abbey/GarminHomeAssistant/blob/main/LICENSE.
//
//-----------------------------------------------------------------------------------
//
// GarminHomeAssistant is a Garmin IQ application written in Monkey C and routinely
// tested on a Venu 2 device. The source code is provided at:
//            https://github.com/house-of-abbey/GarminHomeAssistant.
//
// P A Abbey & J D Abbey & Someone0nEarth, 17 November 2023
//
//
// Description:
//
// MenuItems Factory.
//
//-----------------------------------------------------------------------------------

using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;

class HomeAssistantMenuItemFactory {
    private var mMenuItemOptions      as Lang.Dictionary;
    private var mTapTypeIcon          as WatchUi.Bitmap;
    private var mGroupTypeIcon        as WatchUi.Bitmap;
    private var mInfoTypeIcon         as WatchUi.Bitmap;
    private var mHomeAssistantService as HomeAssistantService;

    private static var instance;

    private function initialize() {
        mMenuItemOptions = {
            :alignment => Settings.getMenuAlignment()
        };

        mTapTypeIcon = new WatchUi.Bitmap({
            :rezId => $.Rez.Drawables.TapTypeIcon,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_CENTER
        });

        mGroupTypeIcon = new WatchUi.Bitmap({
            :rezId => $.Rez.Drawables.GroupTypeIcon,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_CENTER
        });

        mInfoTypeIcon = new WatchUi.Bitmap({
            :rezId => $.Rez.Drawables.InfoTypeIcon,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_CENTER
        });

        mHomeAssistantService = new HomeAssistantService();
    }

    static function create() as HomeAssistantMenuItemFactory {
        if (instance == null) {
            instance = new HomeAssistantMenuItemFactory();
        }
        return instance;
    }

    function toggle(
        label     as Lang.String or Lang.Symbol,
        entity_id as Lang.String or Null,
        template  as Lang.String or Null,
        confirm   as Lang.Boolean
    ) as WatchUi.MenuItem {
        return new HomeAssistantToggleMenuItem(
            label,
            template,
            confirm,
            { "entity_id" => entity_id },
            mMenuItemOptions
        );
    }

    function tap(
        label    as Lang.String or Lang.Symbol,
        entity   as Lang.String or Null,
        template as Lang.String or Null,
        service  as Lang.String or Null,
        confirm  as Lang.Boolean,
        data     as Lang.Dictionary or Null
    ) as WatchUi.MenuItem {
        if (entity != null) {
            if (data == null) {
                data = { "entity_id" => entity };
            } else {
                data.put("entity_id", entity);
            }
        }
        if (service != null) {
            return new HomeAssistantTapMenuItem(
                label,
                template,
                service,
                confirm,
                data,
                mTapTypeIcon,
                mMenuItemOptions,
                mHomeAssistantService
            );
        } else {
            return new HomeAssistantTapMenuItem(
                label,
                template,
                service,
                confirm,
                data,
                mInfoTypeIcon,
                mMenuItemOptions,
                mHomeAssistantService
            );
        }
    }

    function group(
        definition as Lang.Dictionary,
        template   as Lang.String or Null
    ) as WatchUi.MenuItem {
        return new HomeAssistantGroupMenuItem(
            definition,
            template,
            mGroupTypeIcon,
            mMenuItemOptions
        );
    }
}
