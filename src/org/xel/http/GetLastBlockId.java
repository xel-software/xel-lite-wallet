/*
 * Copyright © 2013-2016 The Nxt Core Developers.
 * Copyright © 2016-2017 Jelurida IP B.V.
 *
 * See the LICENSE.txt file at the top-level directory of this distribution
 * for licensing information.
 *
 * Unless otherwise agreed in a custom licensing agreement with Jelurida B.V.,
 * no part of the Nxt software, including this file, may be copied, modified,
 * propagated, or distributed except according to the terms contained in the
 * LICENSE.txt file.
 *
 * Removal or modification of this copyright notice is prohibited.
 *
 */

package org.xel.http;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.JSONStreamAware;

import org.xel.Account;
import org.xel.Nxt;

public final class GetLastBlockId extends APIServlet.APIRequestHandler {

    static final GetLastBlockId instance = new GetLastBlockId();
    public static long lastBlockId = 0;
    public static long lastBlockIdComp = 0;

    private GetLastBlockId() {
        super(new APITag[] {APITag.INFO}, "none");
    }

    @Override
    protected JSONStreamAware processRequest(HttpServletRequest req) {

        JSONObject o = new JSONObject();
        o.put("lastBlock", Long.toUnsignedString(getLastBlock()));
        Account account = null;
        try {
            account = ParameterParser.getAccount(req, false);
        } catch (ParameterException e) {
        }
        return o;
    }

    @Override
    protected boolean allowRequiredBlockParameters() {
        return false;
    }

    public static long getLastBlock() {
        if(lastBlockId==0){
            lastBlockId = Nxt.getBlockchain().getLastBlock().getId();
        }
        return lastBlockId;
    }
}
