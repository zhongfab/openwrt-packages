/*
 * This file is part of Adblock Plus <https://adblockplus.org/>,
 * Copyright (C) 2006-present eyeo GmbH
 *
 * Adblock Plus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Adblock Plus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Adblock Plus.  If not, see <http://www.gnu.org/licenses/>.
 */

import { type Command } from "../../../ipm/background";
import { type Timing } from "../timing.types";

/**
 * On-page dialog command parameters
 */
export interface DialogParams {
  timing: Timing;
  display_duration?: number;
  sub_title: string;
  upper_body: string;
  lower_body?: string;
  button_label: string;
  button_target: string;
  domain_list?: string;
  license_state_list?: string;
}

/**
 * A valid IPM command for an on page dialog command.
 */
export type DialogCommand = Command & DialogParams;
